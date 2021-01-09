//
//  ProfileFilterCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/16/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    var icon: String! {
        didSet {
            let image = UIImage(named: icon)
            iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            iconImageView.tintColor = isSelected  ? .black : UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    
    fileprivate let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.5)//baseWhiteColor//.lightGray
        return imageView
    }()
   
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(iconImageView)
        iconImageView.centerInSuperview(size: .init(width: 23, height: 23))
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
