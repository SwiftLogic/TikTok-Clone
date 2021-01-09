//
//  ProfileFilterOptions.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/17/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  Struct
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
enum ProfileFilterOptions: Int, CaseIterable {
    
    case allPosts
    case likedPosts
    case privatePosts
    

    var imageNames: String {
        switch self {
        case .allPosts: return "allPostsIcon"
        case .likedPosts: return "likedPostsIcon"
        case .privatePosts: return "privatePostsIcon"
        }
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2020 SamiSays11 All rights reserved.
    
    
}
