//
//  LoggingView.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/21.
//

import SwiftUI

struct LoggingView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.messages, id: \.self) { message in
                    VStack(alignment: .trailing, spacing: 0.0) {
                        Text("heartRate: \(Int(message["heartRate"] ?? 0)) bpm")
                            .font(.body)
                            .padding(.vertical, 4.0)
                        Text("time: \(Int(message["time"] ?? 0)) ms")
                            .font(.footnote)
                            .padding(.vertical, 4.0)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView()
            .environmentObject(ViewModel())
    }
}
