//
//  ControlsView.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/06/27.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    workoutManager.endWorkout()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("End")
                })
                .foregroundColor(.red)
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
