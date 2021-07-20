//
//  SettingView.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/08.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var networkClient: NetworkClient
    
    @State var ip: String = "127.0.0.1"
    @State var port: String = "5000"
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("IP")
                    .padding(.leading, 16.0)
                    .font(.headline)
                Spacer()
                TextField("IP", text: $ip)
                    .padding()
            }
            HStack {
                Text("Port")
                    .padding(.leading, 16.0)
                    .font(.headline)
                Spacer()
                TextField("Port", text: $port)
                    .padding()
            }
            HStack {
                Button(action: {
                    self.networkClient.open(ip: self.ip, port: UInt16(self.port)!)
                }) {
                    Text("Connect")
                        .padding(3)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
                Spacer()
                Button(action: {
                    self.networkClient.close()
                }) {
                    Text("Kill")
                        .padding(3)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                }
            }
        }
        .frame(alignment: .center)
        .padding(10)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(NetworkClient())
    }
}
