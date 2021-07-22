//
//  NetworkClient.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/08.
//

import Foundation
import Network

class NetworkClient: ObservableObject {
    var connection: NWConnection?
    
    func open(ip: String, port: UInt16) {
        let host = NWEndpoint.Host(ip)
        let port = NWEndpoint.Port(integerLiteral: port)
        self.connection = NWConnection(host: host, port: port, using: .udp)
        self.connection?.stateUpdateHandler = { (newState) in
            switch(newState) {
            case .ready:
                print("[NetworkClient] Ready")
            case .waiting(let e):
                print("[NetworkClient] Waiting - \(e.localizedDescription)")
            case .failed(let e):
                print("[NetworkClient] Failed - \(e.localizedDescription)")
            case .setup:
                print("[NetworkClient] Setup")
            case .cancelled:
                print("[NetworkClient] Cancelled")
            case .preparing:
                print("[NetworkClient] Preparing")
            default:
                print("[NetworkClient] Default")
            }
        }
        let netQueue = DispatchQueue(label: "NetworkClient")
        self.connection?.start(queue: netQueue)
    }
    
    func send(_ text: String) {
        let data = text.data(using: .utf8)!
        
        self.connection?.send(content: data, completion: .contentProcessed { (error) in
            if let e = error {
                print("[NetworkClient] Error: \(e.localizedDescription)")
            } else {
                print("[NetworkClient] Sent: \(text) (\(data))")
            }
        })
    }
    
    func close() {
        print("[NetworkClient] Close")
        self.connection?.cancel()
    }
}
