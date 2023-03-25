//
//  LoginView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var vm = LoginViewModel()
    
    
    var body: some View {
        VStack(spacing: 10){
            Text("Let's sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            Text("Welcome back \nyou have been missed")
                .font(.title3)
                .hAlign(.leading)
            VStack(spacing: 12){
                TextField("Email", text: $vm.email)
                    .textContentType(.emailAddress)
                    .border()
                    .padding(.top, 25)
                SecureField("Password", text: $vm.password)
                    .textContentType(.emailAddress)
                    .border()
                
                Button(action: vm.resetPassword, label: {
                    Text("forgot password?")
                        .font(.callout)
                        .fontWeight(.medium)
                        .hAlign(.trailing)
                })
                
                Button("Sign in ", action: vm.login)
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
                
            }
            HStack{
                Text("Don't have an acount?")
                    .foregroundColor(.gray)
                Button("Register Now", action: {
                    vm.isRegisterMode.toggle()
                })
                .foregroundColor(.black)
                .fontWeight(.bold)
                
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .fullScreenCover(isPresented: $vm.isRegisterMode, content: {
            RegisterView()
        })
        .overlay(content: {
            LoadingView(show: $vm.isLoading)
        })
        .alert(vm.errorMessage, isPresented: $vm.needShowError, actions: {})
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice(.init(rawValue: "iPhone 14"))
    }
}
