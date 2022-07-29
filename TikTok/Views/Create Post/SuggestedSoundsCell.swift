//
//  SuggestedSoundsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 5/2/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class SuggestedSoundsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        layer.cornerRadius = 4
    }
    
    
    
    
    //MARK: - Properties
    var music: Music! {
        didSet {
            imageView.image = UIImage(named: music.coverPhotoUrl)
            titleLabel.text = music.title
        }
    }
    
     let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 2.5
        return imageview
    }()
    
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11.5)
        label.textAlignment = .center
        return label
    }()
    
    
    let searchButton: UIButton = {
        let button =  UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .large)
        let normalImage = UIImage(systemName: "magnifyingglass", withConfiguration: symbolConfig)!
        button.setImage(normalImage, for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        let cont_width = frame.width - 20
        imageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: cont_width, height: cont_width))
        imageView.centerXInSuperview()
        
        titleLabel.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    
    func handleSetUpHeaderCellData() {
        titleLabel.text = "More"
        imageView.backgroundColor = UIColor.rgb(red: 61, green: 61, blue: 61)
        imageView.addSubview(searchButton)
        searchButton.centerInSuperview()
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
