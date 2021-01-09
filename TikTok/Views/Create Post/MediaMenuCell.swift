//
//  MediaMenuCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/25/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class MediaMenuCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    
    let menuLabel: UILabel = {
           let label = UILabel()
           label.textColor = .gray
           label.font = UIFont.systemFont(ofSize: 16)
           return label
       }()
       
       
   override var isSelected: Bool {
       didSet {
           menuLabel.textColor = isSelected ? .black : .gray
           menuLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
       }
   }
   
   
   
   
   //MARK: - Handlers
   
   fileprivate func setUpViews() {
       addSubview(menuLabel)
       menuLabel.centerInSuperview(size: .zero)
   }


    
    
   
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
