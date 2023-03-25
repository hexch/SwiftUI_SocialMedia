//
//  PostsView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI

struct PostsView: View {
    @StateObject var vm: PostsViewModel
    
    var body: some View {
        NavigationStack{
            ReusablePostsView(
                vm: ReusablePostsViewModel(),
                posts: $vm.posts
            )
            .vAlign(.center)
            .hAlign(.center)
            .overlay(alignment: .bottomTrailing){
                Button(action: {
                    vm.isNewPostPresent.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(13)
                        .background(.black, in: Circle())
                })
                .padding(15)
            }
            .navigationTitle("Post's")
        }
        .fullScreenCover(
            isPresented: $vm.isNewPostPresent,
            content: {
                NewPostView(vm: NewPostViewModel(), callback: {
                    newPost in
                    if let newPost{
                        self.vm.posts.insert(newPost, at: 0)
                    }
                })
            }
        )
        .hAlign(.leading)
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(vm: PostsViewModel())
    }
}
