//
//  FavoriteSoundsCell.swift
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
class FavoriteSoundsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wizkid_superstar")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    
    
    fileprivate let musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = defaultFont(size: 15.5)
        label.text = "original sound - aymieand..."
        label.numberOfLines = 0
        return label
    }()
    
    
    fileprivate let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.5)
        label.text = "Amy"
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    
    
    fileprivate let musicDurationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.5)
        label.text = "Amy"
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    
    fileprivate let rightButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .medium)
        let normalImage = UIImage(systemName: "text.alignright", withConfiguration: symbolConfig)!
        button.setImage(normalImage, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    
    fileprivate let playButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let normalImage = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)!
        button.setImage(normalImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(imageView)
        addSubview(musicTitleLabel)
        addSubview(artistNameLabel)
        addSubview(musicDurationLabel)
        addSubview(rightButton)
        imageView.addSubview(playButton)
        
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: BookmarkedHashtagsCell.cellDimen, height: 0))
        
        
        musicTitleLabel.anchor(top: imageView.topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 12, bottom: 0, right: 0))
        
        artistNameLabel.anchor(top: musicTitleLabel.bottomAnchor, leading: musicTitleLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))

        
        musicDurationLabel.anchor(top: artistNameLabel.bottomAnchor, leading: musicTitleLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))


        rightButton.centerYInSuperview()
        rightButton.constrainToRight(paddingRight: -20)
        
        playButton.centerInSuperview()
    }
    
    /// sets image button and changes imageview cornerRadius
     func setImageForButton(imageName: String) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15.5, weight: .bold, scale: .medium)
        let normalImage = UIImage(systemName: imageName, withConfiguration: symbolConfig)!
        rightButton.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.tintColor = .black
    }
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
