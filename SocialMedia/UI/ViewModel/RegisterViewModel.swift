//
//  RegisterView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userBio: String = ""
    @Published var userBioLink: String = ""
    @Published var username: String = ""
    
    @Published var userPicData: Data?
    @Published var showPhotoPicker:Bool = false
    @Published var photoItem: PhotosPickerItem?
    
    @Published var isErrorPresented: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    var currentUserUID: String? {
        Auth.auth().currentUser?.uid
    }
    func register(){
        isLoading = true
        Task{
            do{
                // Step 1: create a new user
                try await Auth.auth().createUser(withEmail: email, password: password)
                // Step 2: upload photo
                guard let userUID = currentUserUID else{
                    await MainActor.run{
                        isLoading = false
                    }
                    return
                }
                
                var photoUrl: URL?
                if let userPicData{
                    let storageRef = Storage.storage().reference().child("ProfileImages").child(userUID)
                    let _ = try await storageRef.putDataAsync(userPicData)
                    // Step 3: get download url
                    photoUrl = try await storageRef.downloadURL()
                }
                // Step 4: create a user object for firestore database
                let registeredUser = User(name: username, bio: userBio, bioLink: userBioLink, uid: userUID, email: email, photoLink: photoUrl?.absoluteString)
                
                // Step 5:
                let _ = try  Firestore.firestore().collection("Users").document(userUID).setData(from: registeredUser, completion: {
                    error in
                    if let error {
                        print(error)
                    }else{
                        print("save sucessful")
                    }
                })
                
                await MainActor.run{
                    isLoading = false
                }
            }catch{
                await showError(error)
            }
        }
    }
    // MARK: Displaying error VIA Alart
    func showError(_ error: Error) async {
        await MainActor.run{
            isLoading = false
            errorMessage = error.localizedDescription
            isErrorPresented.toggle()
        }
    }
    func validInput()-> Bool{
        email.isEmpty || password.isEmpty || username.isEmpty
    }
}
