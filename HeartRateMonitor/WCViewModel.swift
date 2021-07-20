//
//  WCViewModel.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/19.
//

import Foundation
import WatchConnectivity

final class WCViewModel: NSObject, ObservableObject {
    @Published var messages: [String] = []
    
    var session: WCSession
    var networkClient = NetworkClient()
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension WCViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            let timer = message["timer"] as? String ?? "NaN"
            let heartRate = message["heartRate"] as? String ?? "NaN"
            let text = "\(timer),\(heartRate)"
            self.networkClient.send(text: text)
            self.messages.append(text)
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
