//
//  PostCardView.swift
//  SosyalMedia
//
//  Created by Ayhan on 3.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct PostCardView: View {
    
    var post: Post
    var onUpdate: (Post)->()
    var onDelete: ()->()
    
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListner: ListenerRegistration?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
           VStack(alignment: .leading, spacing: 6){
                Text(post.userName)
                    .font(.callout)
                    .fontWeight(.semibold)
                
               if let postImageURL = post.imageURL{
                    GeometryReader{
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous ))
                    }
                    .padding(.top, 10)
                    .frame(height: 500)
                }
               Text(post.text)
                   .textSelection(.enabled)
                   .padding(.vertical,8)
               
                PostInteraction()
                
                
           Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .hAlign(.leading)
        .overlay(alignment: .topTrailing, content: {
            if post.userUID == userUID{
                Menu{
                    Button("Delete Post",role: .destructive,action: deletePost  )
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption )
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                .offset(x: 8)
            }
        })
        .onAppear{
            if docListner == nil{
                guard let postID = post.id else{return}
                docListner = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot{
                        if snapshot.exists{
                            if let updatedPost = try? snapshot.data(as: Post.self){
                                onUpdate(updatedPost)
                            }
                        }else{
                            onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear{
                if let docListner{
                docListner.remove()
                self.docListner = nil
            }
        }
    }
    @ViewBuilder
    func PostInteraction()->some View{
        HStack(spacing: 6){
           Button(action: likePost){
                Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                   .font(.title3)
                   .foregroundColor(Color("bg"))
            }
            
            Text("\(post.likedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button{
                
            }label: {
                Image(systemName: "message")
                   .font(.title3)
                   .foregroundColor(Color("bg").opacity(0.5))
                Image(systemName: "paperplane")
                   .font(.title3)
                   .foregroundColor(Color("bg").opacity(0.5))
            }
        }
        .foregroundColor(.black)
        .padding(.vertical,8)
    }
    
    func likePost(){
        Task{
            
            guard let postID = post.id else{return}
            
            if post.likedIDs.contains(userUID){
               
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
                
            }else{
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID]),
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    
    func dislikePost(){
        Task{
            
            guard let postID = post.id else{return}
            
            if post.dislikedIDs.contains(userUID){
               
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
                
            }else{
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID]),
                    "dislikedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    func deletePost(){
        Task{
            do{
                if post.imageReferenceID != ""{
                   try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
