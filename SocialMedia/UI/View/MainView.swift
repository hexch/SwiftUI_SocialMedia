//
//  MainView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            PostsView(vm: PostsViewModel())
                .tabItem{
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
            ProfileView(vm: ProfileViewModel())
                .tabItem{
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
