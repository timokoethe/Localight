//
//  SettingsView.swift
//  Localight
//
//  Created by Timo Köthe on 10.01.26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var vm: ChatViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Toggle("Stream Repsonse", isOn: $vm.isStreaming)

                HStack {
                    Text("Instructions: ")
                    Text(vm.instructions)
                }
                
                HStack {
                    Text("Temperature:")
                    Spacer()
                    Text(vm.temperature.description)
                }
            }
            .navigationTitle("Information")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(vm: ChatViewModel())
}
