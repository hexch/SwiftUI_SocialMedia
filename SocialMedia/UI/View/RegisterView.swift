//
//  RegisterView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

// MARK: Register View
struct RegisterView: View{
    @StateObject var vm = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10){
            Text("Let's create an account")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            Text("Hello user\nHave a wonderfull journey")
                .font(.title3)
                .hAlign(.leading)
            
            // MARK: For smaller size screen optimization
            ViewThatFits{
                ScrollView(.vertical, showsIndicators: false, content: {helperView()})
                helperView()
            }
            HStack{
                Text("Already have an acount?")
                    .foregroundColor(.gray)
                Button("Login Now", action: {
                    dismiss()
                })
                .foregroundColor(.black)
                .fontWeight(.bold)
                
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .photosPicker(isPresented: $vm.showPhotoPicker, selection: $vm.photoItem)
        .onChange(of: vm.photoItem, perform: {
            newValue in
            guard let newValue else { return }
            
            Task{
                do{
                    guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                    // MARK: must update in main thread
                    await MainActor.run{
                        vm.userPicData = imageData
                    }
                }catch{}
            }
        })
        .onChange(of: vm.isLoading, perform: {_ in
            if vm.currentUserUID != nil {
                dismiss()
            }
        })
        .overlay{
            LoadingView(show: $vm.isLoading)
        }
        .alert(vm.errorMessage, isPresented: $vm.isErrorPresented, actions: {})
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    @ViewBuilder
    func helperView()-> some View{
        VStack(spacing: 12){
            ZStack{
                if let userPicData = vm.userPicData, let image = UIImage(data: userPicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }else{
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding()
            .frame(width: 85, height: 85)
            .background(Color.blue)
            .clipShape(Circle())
            .contentShape(Circle())
            .padding(.top, 25)
            .onTapGesture {
                vm.showPhotoPicker.toggle()
            }
            
            TextField("User name", text: $vm.username)
                .textContentType(.emailAddress)
                .border()
                .padding(.top, 25)
            TextField("Email", text: $vm.email)
                .textContentType(.emailAddress)
                .border()
            SecureField("Password", text: $vm.password)
                .textContentType(.emailAddress)
                .border()
            TextField("About you", text: $vm.userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .border()
            
            TextField("Bio Link (Optional)", text: $vm.userBioLink)
                .border()
            
            Button("Sign Up", action: vm.register)
                .foregroundColor(.white)
                .hAlign(.center)
                .fillView(.black)
                .disableWidthOpacity(vm.validInput())
            
            
        }
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
