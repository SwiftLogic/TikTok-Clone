//
//  UserSession.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/4/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
class UserSession {
    
    //MARK: - Init
     init() {
        handleFetchCurrentUser()
    }
    
    
    //MARK: - Properties
    static let shared = UserSession()
    var CURRENT_USER: User? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateUserData, object: nil)
        }
    }
    
    
    
    //MARK: - Handlers
    func handleFetchCurrentUser() {
       guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(currentUid).observe(.value) { snapshot in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let user = User(uid: snapshot.key, dictionary: dict)
            self.CURRENT_USER = user
        }
   }
    
    
}



extension Notification.Name {
    /// for recieving updates about user data
    static let didUpdateUserData = Notification.Name("didUpdateUserData")
}


//extension Notification.Name {
//    static let didReceiveData = Notification.Name("didReceiveData")
//    static let didCompleteTask = Notification.Name("didCompleteTask")
//    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
//}
