//
//  LoginView.swift
//  SosyalMedia
//
//  Created by Ayhan on 31.12.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    
    @State var emailID: String = ""
    @State var Password: String = ""
    @State var creatAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        VStack (spacing: 10){
            Text("Lets Sign You In")
                .font(.largeTitle.bold())
            
                .hAlign(.leading)
            
            Text("Welcome Back,\nYou have been missed")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                SecureField("Password", text: $Password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset Password?", action: ressetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button(action: loginUser){
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                     
                }
                .padding(.top, 10)
                
            }
            
            HStack{
                Text("Don't have an account")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    creatAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .fullScreenCover(isPresented: $creatAccount){
            RegisterView()
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    func loginUser(){
        isLoading = true
        closeKeyboard()
        
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: Password)
                print("User Found")
                try await fetcUser()
            }catch{
                await setError(error)
                
            }
        }
    }
    
    
    func fetcUser()async throws{
        guard let userID = Auth.auth().currentUser?.uid else {return}
       let user = try await Firestore.firestore().collection("User").document(userID).getDocument(as: User.self)
        await MainActor.run(body:{
            userUID = userID
            userNameStored = user.userName
            profileURL = user.userProfileURL
            logStatus = true
            
        })
    }
    
    
    func ressetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
