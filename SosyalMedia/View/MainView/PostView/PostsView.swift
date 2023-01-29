//
//  PostsView.swift
//  SosyalMedia
//
//  Created by Ayhan on 2.01.2023.
//

import SwiftUI

struct PostsView: View {
    @State private var recentsPosts: [Post] = []
    @State private var creatNewPost: Bool = false
    
    var body: some View {
        NavigationStack{
            RusablePostsView(posts: $recentsPosts)
                 .hAlign(.center).vAlign(.center)
                 .overlay(alignment: .bottomTrailing){
                     Button{
                         creatNewPost.toggle()
                     }label: {
                         Image(systemName: "plus")
                             .font(.title3)
                             .fontWeight(.semibold)
                             .foregroundColor(.white)
                             .padding(13)
                             .background(Color("bg"), in: Circle())
                     }
                     .padding(15)
                 }
                 .toolbar(content: {
                     ToolbarItem(placement: .navigationBarTrailing) {
                         NavigationLink {
                             SearchView()
                         } label: {
                             Image(systemName: "magnifyingglass")
                                 .tint(.black)
                                 .scaleEffect(0.9)
                         }
                     }
                 })
                 .navigationTitle("Luman")
        }
        .fullScreenCover(isPresented: $creatNewPost){
            CreatNewPost { post in
                recentsPosts.insert(post, at: 0)
                
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
