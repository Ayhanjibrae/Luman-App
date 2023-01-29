//
//  SearchView.swift


import SwiftUI
import FirebaseFirestore
struct SearchView: View {
    
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fetchedUsers) { user in
                NavigationLink {
                    ReusableProfileContent(user: user)
                } label: {
                    Text(user.userName)
                        .font(.callout)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search User")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            Task{await searchUser()}
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedUsers = []
            }
        })
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Cancel") {
//                    dismiss()
//                }
//                .tint(.black)
//            }
//        }
    }
    
    func searchUser() async {
        do {
        
            let documents = try await Firestore.firestore().collection("User").whereField("userName", isGreaterThanOrEqualTo: searchText).whereField("userName", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }

            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
