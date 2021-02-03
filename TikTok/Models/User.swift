//
//  User.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 2/1/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
struct User {
    
    let uid: String
    var username: String
    var fullname: String
    var email: String
    let memberSince: Date
    var birthday: Date
    let followingCount: Int
    let followersCount: Int
    let likeCount: Int
    let postCount: Int

    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        let secondsFrom1970 = dictionary["memberSince"] as? Double ?? 0
        self.memberSince = Date(timeIntervalSince1970: secondsFrom1970)
        let secondsFrom1970ForDOB = dictionary["birthday"] as? Double ?? 0
        self.birthday = Date(timeIntervalSince1970: secondsFrom1970ForDOB)
        
        self.followingCount = dictionary["followingCount"] as? Int ?? 0
        self.followersCount = dictionary["followersCount"] as? Int ?? 0
        self.likeCount = dictionary["likeCount"] as? Int ?? 0
        self.postCount = dictionary["postCount"] as? Int ?? 0


    }

    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    
}
