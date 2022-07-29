//
//  FilterMenuCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/5/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class FilterMenuCell: UICollectionViewCell {
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    var menuTitle: String! {
        didSet {
            titleLabel.text = menuTitle
        }
    }
    
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .black : .gray
            titleLabel.font = isSelected ? defaultFont(size: 15) : appleSDGothicNeoMedium(size: 15.5)
        }
    }
    

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = appleSDGothicNeoMedium(size: 15.5)
        label.textColor = .gray
        return label
    }()
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(titleLabel)
        titleLabel.centerInSuperview()
    }
    
    
    //MARK: - Target Selectors
    
}
