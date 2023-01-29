//
//  ReusableProfileContent.swift
//  SosyalMedia
//
//  Created by Ayhan on 1.01.2023.


import SwiftUI
import SDWebImageSwiftUI

// Burasi Istedigin Tasarliyabilecegim Profile Bolumu !!

struct ReusableProfileContent: View {
    var user: User
    @State private var fetchedPosts: [Post] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                HStack(spacing: 12){
                    WebImage(url: user.userProfileURL).placeholder{
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            
                            
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading,spacing: 6){
                        Text(user.userName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.userEmail)
                            .font(.system(size: 11))
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                        
                        if let bioLink = URL(string: user.userBioLink){
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.leading)
                }
              
        Text(user.userBio)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .hAlign(.leading)
            .padding(.vertical, 15)
                
               // Text("Post's")
                // .font(.title2)
                //  .fontWeight(.semibold)
                //  .foregroundColor(.black)
                //  .hAlign(.leading)
                //  .padding(.vertical, 15)
                
                RusablePostsView(basedOnUID: true, uid: user.userUID, posts: $fetchedPosts)
            }
            .padding(11)
        }
    }
}
