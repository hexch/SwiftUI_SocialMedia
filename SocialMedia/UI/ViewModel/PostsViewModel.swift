//
//  PostsViewModel.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI

class PostsViewModel: ObservableObject{
    @Published var isNewPostPresent = false
    @Published var posts: [Post] = []
}
