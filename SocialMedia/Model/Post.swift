//
//  Post.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable{
    @DocumentID var id: String?
    var text: String
    var imageLink: String?
    var imageReferenceId: String = ""
    var publishedDate: Date = Date()
    var likedIds: [String] = []
    var dislikedIds: [String] = []
    var userName: String
    var userUID: String
    var userPhotoLink: String?
    
    enum CodingKeys: CodingKey{
        case id, text, imageLink, imageReferenceId, publishedDate, likedIds, dislikedIds, userName, userUID, userPhotoLink
    }
}
extension Post{
    var userPhotoLinkUrl: URL?{
        guard let userPhotoLink else { return nil }
        return URL(string: userPhotoLink)
    }
    var imageLinkUrl: URL?{
        guard let imageLink else { return nil }
        return URL(string: imageLink)
    }
}
extension Post{
#if DEBUG
    static let sample = Post(
        text: "test post",
        likedIds: ["testId1", "testId2"],
        dislikedIds: ["testId3", "testId4", "testId5"],
        userName: "test user",
        userUID: "test uid"
    )
#endif
}
