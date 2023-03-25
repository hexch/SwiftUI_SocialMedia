//
//  ProfileViewModel.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var needShowError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var user: User? = nil
    @AppStorage(StorageKey.loginUser.rawValue) var loginUserData: Data?
    
    init(){
        if let loginUserData{
            user = try? JSONDecoder().decode(User.self, from: loginUserData)
        }
    }
    // MARK: Loging user out
    func logout(){
        try? Auth.auth().signOut()
        loginUserData = nil
    }
    // MARK: Delete user account
    func deleteUser(){
        isLoading = true
        Task{
            guard let uid = Auth.auth().currentUser?.uid else { return }
            do{
                // STEP 1: delete auth account
                try await Auth.auth().currentUser?.delete()
                await MainActor.run{
                    loginUserData = nil
                }
                // STEP 2: delete document
                try await Firestore.firestore().collection("Users").document(uid).delete()
                // STEP 3: delete profile image from Storage
                let ref = Storage.storage().reference().child("ProfileImages").child(uid)
                try await ref.delete()
                await MainActor.run{
                    isLoading = false
                }
            }catch{
                await showError(error)
            }
        }
    }
    func fetchUser(){
        Task{
            await fetchUserAsync()
        }
    }
    func fetchUserAsync()async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let fetchedUser = try? await Firestore.firestore().collection("Users").document(uid).getDocument(as: User.self) else { return }
        await MainActor.run(body: {
            user = fetchedUser
            if let encoded = try? JSONEncoder().encode(fetchedUser){
                loginUserData = encoded
            }
        })
    }
    func showError(_ error: Error)async {
        await MainActor.run{
            errorMessage = error.localizedDescription
            needShowError.toggle()
            isLoading = false
        }
    }
}

