//
//  PagingView.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/06/27.
//

import SwiftUI

struct PagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            MetricsView()
            ControlsView()
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        PagingView().environmentObject(WorkoutManager())
    }
}
