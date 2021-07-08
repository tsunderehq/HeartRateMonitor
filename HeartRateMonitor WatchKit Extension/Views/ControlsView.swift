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
                    Image(systemName: "xmark")
                })
                .foregroundColor(.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button(action: {
                    workoutManager.togglePause()
                }, label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                })
                .foregroundColor(.yellow)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
