//
//  StartView.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/06/27.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutType: HKWorkoutActivityType = .other
    
    var body: some View {
        NavigationLink(
            "Start",
            destination: PagingView(),
            tag: workoutType,
            selection: $workoutManager.workoutType
        )
        .padding(
            EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
        )
        .onAppear(perform: {
            workoutManager.requestAuthorization()
        })
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}
