//
//  SettingView.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/08.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("IP")
                    .padding(.leading, 16.0)
                    .font(.headline)
                Spacer()
                TextField("IP", text: $viewModel.ip)
            }
            HStack {
                Text("Port")
                    .padding(.leading, 16.0)
                    .font(.headline)
                Spacer()
                TextField("Port", text: $viewModel.port)
            }
            Toggle(isOn: $viewModel.networkFlag) {
                Text("Connect")
                Image(systemName: "network")
            }
            .toggleStyle(SwitchToggleStyle(tint: .red))
        }
        .frame(alignment: .center)
        .padding(10)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(ViewModel())
    }
}
