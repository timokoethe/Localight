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
/// The model instructions (system prompt) can be edited inline. Because Foundation Models
/// fixes a session’s instructions at creation time, applying a new system prompt rebuilds
/// the session and therefore clears the current chat guarded by a confirmation dialog.
///
/// Data is bound to the provided `ChatViewModel`.
struct SettingsView: View {
    @Bindable var vm: ChatViewModel

    /// Controls the presentation of the save confirmation dialog.
    @State private var showsSaveConfirmation: Bool = false

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
    SettingsView(vm: ChatViewModel())
}
