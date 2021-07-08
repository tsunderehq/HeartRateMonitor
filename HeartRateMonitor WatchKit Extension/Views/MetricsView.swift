//
//  MetricsView.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/06/27.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .leading, content: {
            ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0)
                .foregroundColor(.yellow)
            Text(
                String(workoutManager.heartRate) + " bpm"
            )
        })
        .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
        )
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView().environmentObject(WorkoutManager())
    }
}
