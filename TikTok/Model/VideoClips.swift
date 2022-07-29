//
//  SelectedClips.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 2/15/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  Struct
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
struct VideoClips: Equatable {
        
    let videoUrl: URL
    let cameraPosition: AVCaptureDevice.Position
    
    init(videoUrl: URL, cameraPosition: AVCaptureDevice.Position?) {
        self.videoUrl = videoUrl
        self.cameraPosition = cameraPosition ?? .back
       }
    
    
    static func ==(lhs: VideoClips, rhs: VideoClips) -> Bool {
        return lhs.videoUrl == rhs.videoUrl && lhs.cameraPosition == rhs.cameraPosition
    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    
}


