//
//  ContentView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage(StorageKey.loginUser.rawValue) var loginUserData: Data?
    
    var loginUser: User?{
        if let loginUserData{
            return try? JSONDecoder().decode(User.self, from: loginUserData)
        }else{
            return nil
        }
    }
    var body: some View {
        if loginUser != nil{
            MainView()
        }else{
            LoginView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
