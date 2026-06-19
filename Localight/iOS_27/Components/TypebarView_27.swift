//
//  TypebarView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI
import PhotosUI

/// Provides the iOS 27 input area for composing and sending messages.
struct TypebarView_27: View {
    @Bindable var vm: ChatViewModel_27
    @State private var selectedPhotoItems: [PhotosPickerItem] = []

    var body: some View {
            VStack(spacing: 6) {
                
                if let image = vm.attachedImage {
                    HStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(.rect(cornerRadius: 8))

                        Button("Remove", systemImage: "xmark.circle.fill") {
                            selectedPhotoItems = []
                            vm.removeAttachment()
                        }
                        .labelStyle(.iconOnly)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                }

                HStack {
                    PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 1, matching: .images) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 24)
                            .padding(.vertical, 6)
                            .padding(.leading, 6)
                    }
                    .foregroundStyle(Color("Tint"))
                    .disabled(vm.isResponding)

                    TextField("Type here ...", text: $vm.inputText)
                        .padding(.horizontal, 6)

                    Button(role: .confirm) {
                        Task {
                            if vm.isStreaming {
                                await vm.streamResponse()
                            } else {
                                await vm.getResponse()
                            }
                            selectedPhotoItems = []
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30)
                            .padding(.trailing, 6)
                            .padding(.vertical, 2)
                    }
                    .foregroundStyle(canSend ? Color("Tint") : .gray)
                    .disabled(vm.isResponding)
                    .disabled(!canSend)
                }
            }
            .padding(8)
            .glassEffect(in: .rect(cornerRadius: 16))
            .padding()
            .onChange(of: selectedPhotoItems) { _, items in
                Task {
                    guard let item = items.last,
                          let data = try? await item.loadTransferable(type: Data.self) else {
                        return
                    }
                    guard item == selectedPhotoItems.last else {
                        return
                    }
                    vm.attachImageData(data)
                }
            }
        }


    private var canSend: Bool {
        !vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || vm.attachedImage != nil
    }
}

#Preview {
    TypebarView_27(vm: ChatViewModel_27())
}

#Preview("Typebar with Image") {
    let vm = ChatViewModel_27()
    vm.inputText = "What can you see?"
    vm.attachedImage = UIImage(named: "Portrait")

    return TypebarView_27(vm: vm)
}
