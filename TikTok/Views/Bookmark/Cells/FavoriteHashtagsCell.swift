//
//  FavoriteHashtagsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/6/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class FavoriteHashtagsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpViews()
    
    }
    
    
    
    
    //MARK: - Properties
    fileprivate let imageViewBoxContainer: UIView = {
        let imageViewBoxContainer = UIView()
        imageViewBoxContainer.clipsToBounds = true
        imageViewBoxContainer.backgroundColor = UIColor.rgb(red: 248, green: 248, blue: 248)
        imageViewBoxContainer.layer.borderWidth = 0.9
        imageViewBoxContainer.layer.borderColor = baseWhiteColor.cgColor
        return imageViewBoxContainer
    }()
    
    
    fileprivate let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = hashtagIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let hashtagNameLabel: UILabel = {
        let label = UILabel()
        label.font = defaultFont(size: 14.5)
        label.text = "#viral"
        label.numberOfLines = 0
        return label
    }()
    
    
    fileprivate let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.5)
        label.text = "13.3B views"
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(imageViewBoxContainer)
        imageViewBoxContainer.addSubview(centerImageView)
        addSubview(hashtagNameLabel)
        addSubview(viewsLabel)

        imageViewBoxContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: BookmarkedHashtagsCell.cellDimen - 5, height: 0))
        
        centerImageView.centerInSuperview(size: .init(width: 35, height: 35))
        hashtagNameLabel.anchor(top: imageViewBoxContainer.topAnchor, leading: imageViewBoxContainer.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 0))
        
        viewsLabel.anchor(top: hashtagNameLabel.bottomAnchor, leading: hashtagNameLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
