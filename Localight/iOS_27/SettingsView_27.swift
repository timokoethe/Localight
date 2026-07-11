//
//  SettingsView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI

#if LOCALIGHT_IOS27_SDK
/// Displays chat and model settings for iOS 27.
@available(iOS 27.0, *)
struct SettingsView_27: View {
    @Bindable var vm: ChatViewModel_27
    @State private var showsSaveConfirmation = false
    @State private var showsTemperatureConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Stream responses", isOn: $vm.isStreaming)
                        .tint(Color("Tint"))
                    Toggle("Show token usage", isOn: $vm.showsMessageTokenUsage)
                        .tint(Color("Tint"))
                } header: {
                    Text("Chat")
                } footer: {
                    Text("Controls response streaming and per-message token usage.")
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
                    ProgressView(
                        value: Double(vm.contextTokensUsed),
                        total: Double(vm.contextSize)
                    )
                    .tint(Color("Tint"))
                    Text("\(vm.contextTokensUsed) / \(vm.contextSize) tokens")
                } footer: {
                    Text("The context window used by the current chat.")
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
    SettingsView_27(vm: ChatViewModel_27())
}
#endif
