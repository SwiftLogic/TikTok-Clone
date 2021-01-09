//
//  Post.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/26/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  Struct
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
struct Post {
    
      var postId: String
      var postImageUrl: String
      var videoUrl: String?
      var caption: String?
      let creationDate: Date
      var likes: Int
      var views: Int
      var commentCount: Int
      let ownerUid: String
      var user: TikTokUser
    
    init(user: TikTokUser, dictionary: [String:Any]) {
        self.user = user
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.videoUrl = dictionary["videoUrl"] as? String ?? nil//""
        self.caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.likes = dictionary["likes"] as? Int ?? 0
        self.views = dictionary["views"] as? Int ?? 0
        self.commentCount = dictionary["commentCount"] as? Int ?? 0
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        
    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    
}
