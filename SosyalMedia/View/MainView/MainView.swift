//
//  MainView.swift
//  SosyalMedia
//
//  Created by Ayhan on 1.01.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            PostsView()
                .tabItem {
                    Image(systemName: "homekit")
                    Text("Post's")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
