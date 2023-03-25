//
//  User.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var name: String
    var bio: String?
    var bioLink: String?
    var uid: String
    var email: String
    var photoLink: String?
    
    enum CodingKeys: CodingKey{
        case name,bio,bioLink,uid,email,photoLink
    }
}

extension User{
    var photoLinkUrl: URL?{
        guard let photoLink else{ return nil }
        return URL(string: photoLink)
    }
    var bioLinkUrl: URL?{
        guard let bioLink else { return nil }
        return URL(string: bioLink)
    }
}

extension User{
    static var sample = User(
        id: "temp user",
        name: "test user",
        bio: "test bio test bio test bio test bio test bio test bio test bio test bio test bio test bio bio test",
        bioLink: "https://test.com",
        uid: "testuid",
        email: "test@gmail.com"
    )
}
