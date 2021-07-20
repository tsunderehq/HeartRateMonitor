//
//  LoggingView.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/21.
//

import SwiftUI

struct LoggingView: View {
    @ObservedObject var wcViewModel = WCViewModel()
    @State private var isReachable = "NO"
    
    var body: some View {
            VStack {
                List {
                    ForEach(self.wcViewModel.messages, id: \.self) { message in
                        VStack(alignment: .leading) {
                            Text(message)
                                .font(.body)
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
    }
}
