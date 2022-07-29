//
//  Fonts.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 2/16/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  Struct
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
struct Fonts {
    static let typerWriter = "AltoneTrial-BoldOblique"
    static let handWriting = "Kaibon"
    static let neon = "NEONGLOWHollow"
    static let serif = "SerifBlack"
    static let acherusGrotesque = "AcherusGrotesque-Regular"
    static let soundsGood = "SoundsGood"
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.    
}


///when we need to console log all available font family
public func handleFindFontName() {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("DEBUG Font Family: \(family) Font Names: \(names)")
    }
}

