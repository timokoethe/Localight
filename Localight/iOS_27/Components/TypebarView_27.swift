//
//  TypebarView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI
import PhotosUI

#if LOCALIGHT_IOS27_SDK
/// Provides the iOS 27 input area for composing and sending messages.
@available(iOS 27.0, *)
struct TypebarView_27: View {
    @Bindable var vm: ChatViewModel_27
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var isLoadingAttachment = false

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
                    .disabled(vm.isResponding || !canSend)
                }
            }
            .padding(8)
            .glassEffect(in: .rect(cornerRadius: 16))
            .padding()
            .task(id: selectedPhotoItems) {
                await loadSelectedPhoto()
            }
        }

    private func loadSelectedPhoto() async {
        guard let item = selectedPhotoItems.last else {
            isLoadingAttachment = false
            return
        }

        isLoadingAttachment = true
        vm.removeAttachment()

        guard let data = try? await item.loadTransferable(type: Data.self),
              !Task.isCancelled,
              item == selectedPhotoItems.last else {
            if item == selectedPhotoItems.last {
                isLoadingAttachment = false
            }
            return
        }

        vm.attachImageData(data)
        isLoadingAttachment = false
    }

    private var canSend: Bool {
        !isLoadingAttachment
        && (!vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || vm.attachedImage != nil)
    }
}

@available(iOS 27.0, *)
#Preview {
    TypebarView_27(vm: ChatViewModel_27())
}

@available(iOS 27.0, *)
#Preview("Typebar with Image") {
    let vm = ChatViewModel_27()
    vm.inputText = "What can you see?"
    vm.attachedImage = UIImage(named: "Portrait")

    return TypebarView_27(vm: vm)
}
#endif
