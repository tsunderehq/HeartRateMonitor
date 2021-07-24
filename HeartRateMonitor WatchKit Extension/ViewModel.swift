//
//  ViewModel.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/07/19.
//

import Foundation
import WatchConnectivity

class ViewModel: NSObject, ObservableObject {
    var session: WCSession
    
    init(session: WCSession  = .default) {
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
            print("[WCSession] The session has completed activation.")
        }
    }
}
