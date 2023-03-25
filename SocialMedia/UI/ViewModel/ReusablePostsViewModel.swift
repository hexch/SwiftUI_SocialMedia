//
//  ReusablePostsViewModel.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI
import FirebaseFirestore

class ReusablePostsViewModel: ObservableObject{
    @Published var isLoading: Bool = false
    
    @AppStorage(StorageKey.loginUser.rawValue) var loginUserData: Data?

    var user: User {
       try! JSONDecoder().decode(User.self, from: loginUserData!)
    }
    
    var userUID:String{
        user.uid
    }
    
    
    func fetchPostsAsync(_ completion:([Post])-> Void) async{
        await MainActor.run{
            isLoading = true
        }
        do{
            let query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            let docs = try await query.getDocuments()
            let fetched = docs.documents.compactMap{doc-> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run{
                isLoading = false
                completion(fetched)
            }
        }catch{
            
        }
    }
}
