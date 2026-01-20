//
//  SettingsView.swift
//  Localight
//
//  Created by Timo Köthe on 10.01.26.
//

import SwiftUI

/// A view that displays information for the chat experience, including response streaming,
/// model instructions, and temperature (creativity) parameters.
///
/// Data is bound to the provided `ChatViewModel`.
struct SettingsView: View {
    @Bindable var vm: ChatViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Stream responses", isOn: $vm.isStreaming)
                } footer: {
                    Text("Streams output as it’s generated. Turn off to show the full response at once.")
                }

                Section {
                    HStack {
                        Text("Instructions: ")
                        Text(vm.instructions)
                    }
                } footer: {
                    Text("Instructions guide the model’s behavior and tone for all responses.")
                }
                
                Section {
                    HStack {
                        Text("Temperature:")
                        Spacer()
                        Text(vm.temperature.description)
                    }
                } footer: {
                    Text("Controls how creative the model is. Lower values are more consistent, higher values are more varied.")
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
