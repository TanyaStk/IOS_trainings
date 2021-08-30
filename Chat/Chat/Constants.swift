//
//  Constants.swift
//  Chat
//
//  Created by TanyaSamastr on 23.08.21.
//

import Foundation
import Firebase

struct Constants {
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
