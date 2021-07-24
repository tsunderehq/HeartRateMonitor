//
//  HeartRateMonitorApp.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/07/08.
//

import SwiftUI

@main
struct HeartRateMonitorApp: App {
    @StateObject var workoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
                    .onAppear(perform: {
                        workoutManager.requestAuthorization()
                    })
            }
            .environmentObject(workoutManager)
        }
    }
}
