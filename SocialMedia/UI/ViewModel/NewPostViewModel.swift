//
//  NewPostViewModel.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

class NewPostViewModel: ObservableObject{
    @Published var postText: String = ""
    @Published var postImageData: Data?
    
    @Published var showPhotoPicker: Bool = false
    @Published var photoItem: PhotosPickerItem?
    
    @Published var isLoading: Bool = false
    @Published var isErrorPresented: Bool = false
    @Published var errorMessage: String = ""
    
    @AppStorage(StorageKey.loginUser.rawValue) var loginUserData: Data?

    var user: User {
       try! JSONDecoder().decode(User.self, from: loginUserData!)
    }
    func createPost(_ completion:@escaping (Post)-> Void){
        isLoading = true
        print("photolink:\(user.photoLink ?? "")")
        Task{
            do{
                var imageDownloadUrl: String?
                var imageReferenceId: String?
                
                if let postImageData {
                    imageReferenceId = "\(user.uid)_\(Data())"
                    let storageRef = Storage.storage().reference().child("PostImages").child(imageReferenceId!)
                    
                    let _ = try await storageRef.putDataAsync(postImageData)
                    imageDownloadUrl = try await storageRef.downloadURL().absoluteString
                }
                
                var post = Post(
                    text: postText,
                    imageLink: imageDownloadUrl,
                    imageReferenceId: imageReferenceId ?? "",
                    userName: user.name,
                    userUID: user.uid,
                    userPhotoLink: user.photoLink
                )
                let docRef = Firestore.firestore().collection("Posts").document()
                let _ = try docRef.setData(from: post, completion: {error in
                    if let error {
                        Task{
                            await self.showError(error)
                        }
                        return
                    }
                    self.isLoading = false
                    post.id = docRef.documentID
                    completion(post)
                })
            }catch{
                await showError(error)
            }
        }
    }
    
    func showError(_ error: Error)async {
        await MainActor.run{
            errorMessage = error.localizedDescription
            isErrorPresented.toggle()
            isLoading = false
        }
    }
}
