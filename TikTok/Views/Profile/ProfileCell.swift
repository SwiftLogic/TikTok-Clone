//
//  ProfileCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/15/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class ProfileCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    
    
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sam")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    fileprivate let playIcon: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "playIcon")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = defaultFont(size: 11.5)
        label.text = "59.3K"
        label.UILableTextShadow(color: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        
        
        imageView.addSubview(playIcon)
        playIcon.constrainToLeft(paddingLeft: 10)
        playIcon.constrainToBottom(paddingBottom: -5)
        playIcon.constrainWidth(constant: 15)
        playIcon.constrainHeight(constant: 15)
        
        imageView.addSubview(viewsCountLabel)
        viewsCountLabel.constrainToBottom(paddingBottom: -3)
        viewsCountLabel.leadingAnchor.constraint(equalTo: playIcon.trailingAnchor, constant: 3).isActive = true
        
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
