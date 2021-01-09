//
//  TikTokUser.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/24/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  Struct
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
struct TikTokUser {
    
    
    var username: String
    var queryUsername: String
    var uid: String
    var email: String
    var profileImageUrl: String
    var followersCount: Int
    var followingCount: Int
    var likes: Int
    var bio: String?
    var fcmToken: String
    var postCount: Int
    


    init(uid: String, dictionary: [String:Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.queryUsername = dictionary["queryUsername"] as? String ?? ""
        self.email =  dictionary["email"] as? String ?? ""
        self.profileImageUrl =  dictionary["profileImageUrl"] as? String ?? ""
        self.followersCount = dictionary["followersCount"] as? Int ?? 0
        self.followingCount = dictionary["followingCount"] as? Int ?? 0
        self.likes = dictionary["likes"] as? Int ?? 0
        self.bio = dictionary["bio"] as? String ?? nil
        self.fcmToken = dictionary["fcmToken"] as? String ?? ""
        self.postCount = dictionary["postCount"] as? Int ?? 0


    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    
}
