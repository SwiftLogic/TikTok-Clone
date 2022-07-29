//
//  BookmarkedProductsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/6/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class BookmarkedProductsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .large)
        let normalImage = UIImage(systemName: "bag.badge.plus", withConfiguration: symbolConfig)!
        imageView.image = normalImage
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    
    fileprivate let productLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    
    //MARK: - Handlers
    private func setUpViews() {
        addSubview(imageView)
        addSubview(productLabel)
        imageView.centerXInSuperview()
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60).isActive = true
        
        productLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        productLabel.constrainToRight(paddingRight: -8)
        productLabel.constrainToLeft(paddingLeft: 8)
        
        productLabel.attributedText = setupAttributedTextWithFonts(titleString: "No products yet \n ", subTitleString: "Products added to your Favorites will appear here", attributedTextColor: .gray, mainColor: .black, mainfont: defaultFont(size: 17), subFont: .systemFont(ofSize: 15))
    }
    
    
    
    //MARK: - Target Selectors
}
