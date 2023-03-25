//
//  NewPostView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI

struct NewPostView: View {
    @StateObject var vm: NewPostViewModel
    var callback: (Post?)-> Void
    
    @FocusState var showKeyboard: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            HStack{
                Menu(content: {
                    Button("Cancel", role: .destructive, action: {
                        dismiss()
                    })
                }, label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.red)
                })
                .hAlign(.leading)
                
                Button(action: {
                    showKeyboard = false
                    vm.createPost(){newPost in
                        callback(newPost)
                        dismiss()
                    }
                }, label: {
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.black, in: Capsule())
                })
                .disableWidthOpacity(vm.postText.isEmpty)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 6)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    TextField("What's happening", text: $vm.postText, axis: .vertical)
                        .focused($showKeyboard)
                    if let imageData = vm.postImageData ,
                       let image = UIImage(data: imageData){
                        GeometryReader{
                            let size = $0.size
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                )
                                .overlay(alignment: .topTrailing){
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.25)){
                                            self.vm.postImageData = nil
                                        }
                                    }, label: {
                                        Image(systemName: "trash")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .tint(.red)
                                    })
                                    .padding(10)
                                }
                        }
                        .clipped()
                        .frame(height: 220)
                    }
                }
                .padding(15)
            }
            
            Divider()
            HStack{
                Button(action: {
                    vm.showPhotoPicker.toggle()
                }, label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                })
                
                Spacer()
                
                Button("Done", action: {
                    showKeyboard = false
                })
            }
            .foregroundColor(.black)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .vAlign(.top)
        .alert(vm.errorMessage, isPresented: $vm.isErrorPresented, actions: {})
        .overlay{
            LoadingView(show: $vm.isLoading)
        }
        .photosPicker(isPresented: $vm.showPhotoPicker, selection: $vm.photoItem)
        .onChange(of: vm.photoItem, perform: {
            newValue in
            guard let newValue else { return }
            Task{
                guard let raw = try? await newValue.loadTransferable(type: Data.self) ,
                   let image = UIImage(data: raw) else { return }
                
                let compressed = image.jpegData(compressionQuality: 0.5)
                
                await MainActor.run{
                    vm.postImageData = compressed
                    vm.photoItem = nil
                }
            }
        })
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(vm: NewPostViewModel(), callback: {_ in})
    }
}
