//
//  SettingsView_26.swift
//  Localight
//
//  Created by Timo Köthe on 10.01.26.
//

import SwiftUI

/// The iOS 26 settings view, including response streaming,
/// model instructions, and temperature information.
///
/// The model instructions (system prompt) can be edited inline. Because Foundation Models
/// fixes a session’s instructions at creation time, applying a new system prompt rebuilds
/// the session and therefore clears the current chat guarded by a confirmation dialog.
///
/// Data is bound to the provided `ChatViewModel_26`.
struct SettingsView_26: View {
    @Bindable var vm: ChatViewModel_26

    /// Controls the presentation of the save confirmation dialog.
    @State private var showsSaveConfirmation: Bool = false
    @State private var showsTemperatureConfirmation: Bool = false

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
                    Slider(value: $vm.temperatureDraft, in: 0...1, step: 0.1) {
                        Text("Temperature")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("1")
                    }
                    .tint(Color("Tint"))

                    HStack {
                        Text("Selected value")
                        Spacer()
                        Text(vm.temperatureDraft, format: .number.precision(.fractionLength(1)))
                    }

                    Button("Save") {
                        showsTemperatureConfirmation = true
                    }
                    .disabled(!vm.hasTemperatureChanges)
                } header: {
                    Text("Temperature")
                } footer: {
                    Text("Controls how creative the model is. Saving starts a fresh session and clears the current chat.")
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
            .alert(
                "Save new temperature?",
                isPresented: $showsTemperatureConfirmation
            ) {
                Button("Save", role: .destructive) {
                    vm.applyTemperature()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Applying a new temperature starts a fresh session and clears the current chat.")
            }
        }
    }
}

#Preview {
    SettingsView_26(vm: ChatViewModel_26())
}
