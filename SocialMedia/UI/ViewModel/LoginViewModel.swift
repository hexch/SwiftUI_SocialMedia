//
//  LoginVM.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegisterMode: Bool = false
    @Published var needShowError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @AppStorage(StorageKey.loginUser.rawValue) var loginUserData: Data?
    
    var loginUser: User?{
        if let loginUserData{
            return try? JSONDecoder().decode(User.self, from: loginUserData)
        }else{
            return nil
        }
    }
    func login(){
        isLoading = true
        Task{
            do{
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                print("uid:\(result.user.uid)")
                try await fetchUser()
            }catch{
                await showError(error)
            }
        }
    }
    func fetchUser()async throws{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let user = try await Firestore.firestore().collection("Users").document(uid).getDocument(as: User.self)
        let userData = try JSONEncoder().encode(user)
        await MainActor.run(body: {
            loginUserData = userData
        })
    }
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: email)
            }catch{
                await showError(error)
            }
        }
    }
    func showError(_ error: Error)async {
        await MainActor.run{
            errorMessage = error.localizedDescription
            needShowError.toggle()
            isLoading = false
        }
    }
}
