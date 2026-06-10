//
//  SettingsView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI

/// Displays chat and model settings for iOS 27.
struct SettingsView_27: View {
    @Bindable var vm: ChatViewModel_27
    @State private var showsSaveConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Stream responses", isOn: $vm.isStreaming)
                        .tint(Color("Tint"))
                } footer: {
                    Text("Streams output as it’s generated. Turn off to show the full response at once.")
                }

                Section {
                    TextField("Instructions...", text: $vm.instructionsDraft, axis: .vertical)
                        .lineLimit(2...)

                    Button("Save") {
                        showsSaveConfirmation = true
                    }
                    .disabled(!vm.hasInstructionChanges)
                } header: {
                    Text("Instructions")
                } footer: {
                    Text("Instructions guide the model’s behavior and tone for all responses. Saving applies a new system prompt and clears the current chat.")
                }

                Section {
                    HStack {
                        Text("Context Size")
                        Spacer()
                        Text(vm.contextSize.description)
                    }
                } footer: {
                    Text("The maximum context size in tokens supported by the model.")
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
            .alert(
                "Save new instructions?",
                isPresented: $showsSaveConfirmation
            ) {
                Button("Save", role: .destructive) {
                    vm.applyInstructions()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Applying a new system prompt starts a fresh session and clears the current chat.")
            }
        }
    }
}

#Preview {
    SettingsView_27(vm: ChatViewModel_27())
}
