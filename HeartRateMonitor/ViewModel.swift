//
//  ViewModel.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/19.
//

import Foundation
import WatchConnectivity

class ViewModel: NSObject, ObservableObject {
    var session: WCSession
    
    // network
    var networkClient = NetworkClient()
    @Published var ip: String {
        didSet {
            UserDefaults.standard.set(ip, forKey: "ip")
        }
    }
    @Published var port: String {
        didSet {
            UserDefaults.standard.set(port, forKey: "port")
        }
    }
    @Published var networkFlag: Bool {
        didSet {
            if self.networkFlag {
                self.networkClient.open(ip: self.ip, port: UInt16(self.port)!)
                self.networkClient.send("OPEN")
            } else {
                self.networkClient.close()
            }
        }
    }
    
    // message list
    @Published var messages: [[String: Double]] = []
    
    init(session: WCSession = .default) {
        self.ip = UserDefaults.standard.string(forKey: "ip") ?? "127.0.0.1"
        self.port = UserDefaults.standard.string(forKey: "port") ?? "5000"
        self.networkFlag = false
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension ViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let e = error {
            print(e.localizedDescription)
        } else {
            print("[WatchConnectivitySession] The session has completed activation.")
        }
    }
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let time = message["time"] as! Double
        let heartRate = message["heartRate"] as! Double
        let text = "\(time),\(heartRate)"
        if self.networkFlag {
            self.networkClient.send(text + "\n")
            DispatchQueue.main.async {
                self.messages.append(["time": time, "heartRate": heartRate])
            }
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
