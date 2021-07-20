//
//  HeartRateMonitorApp.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/08.
//

import SwiftUI

@main
struct HeartRateMonitorApp: App {
    @StateObject var networkClient = NetworkClient()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkClient)
        }
    }
}
