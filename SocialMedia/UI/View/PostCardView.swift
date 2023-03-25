//
//  PostCardView.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseStorage

struct PostCardView: View {
    var userUID: String
    var post: Post
    var onUpdate: (Post)-> Void
    var onDelete: ()-> Void
    
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            WebImage(url: post.userPhotoLinkUrl)
                .placeholder{
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .background(Color.blue.opacity(0.3))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35,height: 35)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6){
                Text(post.userName)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(post.text)
                    .textSelection(.enabled)
                    .padding(.vertical,8)
                
                if let imageUrl = post.imageLinkUrl{
                    GeometryReader{
                        let size = $0.size
                        WebImage(url: imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height: 200)
                }
                postInteraction()
            }
        }
        .hAlign(.leading)
        .overlay(alignment: .topTrailing){
            if post.userUID == userUID{
                Menu(content: {
                    Button("Delete Post", role: .destructive, action: deletePost)
                }, label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(-90))
                        .padding(8)
                        .contentShape(Rectangle())
                })
                .offset(x: 8)
            }
        }
        .onAppear{
            guard docListener == nil else { return }
            guard let postId = post.id else { return }
            
            print("onApear : \(postId)")
            docListener = Firestore.firestore().collection("Posts")
                .document(postId).addSnapshotListener{
                    snapshot ,error in
                    guard let snapshot else { return }
                    if snapshot.exists {
                        /// - Document updated
                        if let updated = try? snapshot.data(as: Post.self){
                            onUpdate(updated)
                        }
                    }else{
                        /// - Document deleted
                        print("onDelete :\(post.id ?? "")")
                        onDelete()
                    }
                }
        }
        .onDisappear{
            // MARK: Applying snapshot only when the post is avaliable on the screen
            // else removing the listener (it saves unwanted live update from post swipped from screen)
             
            if let docListener{
                docListener.remove()
                self.docListener = nil
            }
        }
    }
    
    @ViewBuilder
    func postInteraction()-> some View{
        HStack(spacing: 6){
            Button(action: likePost, label: {
                Image(systemName: post.likedIds.contains(userUID) ? "hand.thumbsup.fill" : "hand.thumbsup")
            })
            
            Text("\(post.likedIds.count)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: dislikePost, label: {
                Image(systemName: post.dislikedIds.contains(userUID) ? "hand.thumbsdown.fill" :  "hand.thumbsdown")
            })
            .padding(.leading, 25)
            
            Text("\(post.dislikedIds.count)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.black)
        .padding(.vertical, 8)
    }
    
    func likePost(){
        guard let postId = post.id else { return }
        Task{
            let docRef = Firestore.firestore().collection("Posts").document(postId)
            if post.likedIds.contains(userUID){
                try? await docRef.updateData([
                    "likedIds": FieldValue.arrayRemove([userUID])
                ])
            }else{
                try? await docRef.updateData([
                    "likedIds": FieldValue.arrayUnion([userUID]),
                    "dislikedIds": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    func dislikePost(){
        guard let postId = post.id else { return }
        Task{
            let docRef = Firestore.firestore().collection("Posts").document(postId)
            if post.dislikedIds.contains(userUID){
                try? await docRef.updateData([
                    "dislikedIds": FieldValue.arrayRemove([userUID])
                ])
            }else{
                try? await docRef.updateData([
                    "dislikedIds": FieldValue.arrayUnion([userUID]),
                    "likedIds": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    func deletePost() {
        guard let postId = post.id else { return }
        Task{
            do{
                if !post.imageReferenceId.isEmpty {
                    try await Storage.storage().reference().child("PostImages").child(post.imageReferenceId).delete()
                }
                try await Firestore.firestore().collection("Posts").document(postId).delete()
            }catch{
                print(error)
            }
        }
    }
}


struct PostCardView_Previews: PreviewProvider {
    static var previews: some View {
        PostCardView(userUID: "test uid", post: Post.sample, onUpdate: {_ in}, onDelete: {})
    }
}
