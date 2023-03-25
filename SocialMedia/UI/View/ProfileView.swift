//
//  ProfileView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    var body: some View {
        NavigationStack{
            VStack{
                if let user = vm.user {
                    ReusableProfileContent(user: user)
                        .refreshable {
                            await vm.fetchUserAsync()
                        }
                }else{
                    ProgressView()
                }
            }
            .navigationTitle("My Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button("logout", action: vm.logout)
                        Button("delete", role: .destructive, action: vm.deleteUser)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .scaleEffect(0.8)
                            .tint(.black)
                    }
                }
            }
            .task {
               await vm.fetchUserAsync()
            }
        }
        .overlay{
            LoadingView(show: $vm.isLoading)
        }
        .alert(vm.errorMessage, isPresented: $vm.needShowError){}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel())
    }
}
