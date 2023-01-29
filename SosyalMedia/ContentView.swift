//
//  ContentView.swift
//  SosyalMedia
//
//  Created by Ayhan on 30.12.2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
       if logStatus{
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
