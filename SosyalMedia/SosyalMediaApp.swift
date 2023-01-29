//
//  SosyalMediaApp.swift
//  SosyalMedia
//
//  Created by Ayhan on 30.12.2022.
//

import SwiftUI
import Firebase

@main
struct SosyalMediaApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
           ContentView()
        }
    }
}
