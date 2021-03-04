//
//  FontsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 2/16/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
public let fontSizeInCell: CGFloat = 15
class FontsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    var font: UIFont! {
        didSet {
            guard let newFont = UIFont(name: font.fontName, size: fontSizeInCell) else {return}
            label.font = newFont
        }
    }
    
    
     let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(label)
        label.centerInSuperview()
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
