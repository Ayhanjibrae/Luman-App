//
//  User.swift
//  SosyalMedia
//
//  Created by Ayhan on 31.12.2022.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable  {
    @DocumentID var id: String?
    
    var userName: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum codingKeys: CodingKey {
        case id
        case userName
        case userBioLink
        case userUID
        case userEmail
        case userProfileURL
    }
    
}
