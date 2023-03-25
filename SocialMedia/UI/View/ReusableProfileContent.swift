//
//  ReusableProfileContent.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    var user: User
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                HStack(spacing: 12, content: {
                    WebImage(url: user.photoLinkUrl)
                        .placeholder{
                            Image(systemName: "person")
                                .resizable()
                                .padding()
                                .background(Color.blue.opacity(0.3))
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 12){
                        Text(user.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.bio ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        if let url = user.bioLinkUrl {
                            Link(url.absoluteString, destination: url)
                                .font(.callout)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.leading)
                })
                
                Text("Post's")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAlign(.leading)
                    .padding(.vertical, 15)
            }
            .padding(15)
        }
    }
}

struct ReusableProfileContent_Previews: PreviewProvider {
    static var previews: some View {
        ReusableProfileContent(user: User.sample)
    }
}
