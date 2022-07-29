//
//  EditProfileCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/1/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class EditProfileCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    var editProfile: EditProfile! {
        didSet {
            nameOfInfoLabel.text = editProfile.infoName
            if editProfile.infoValue != "" {
                valueOfInfoLabel.text = editProfile.infoValue
                valueOfInfoLabel.textColor = UIColor.black.withAlphaComponent(0.8)
            } else {
                valueOfInfoLabel.text = editProfile.placeHolderText
                valueOfInfoLabel.textColor = .lightGray
            }
        }
    }
    
    
    private let nameOfInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = tikTokFont(size: 14.2)//appleSDGothicNeoMedium(size: 14.5)
        label.textAlignment = .left
        return label
    }()
    
    private let valueOfInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = tikTokFont(size: 14.2)//appleSDGothicNeoMedium(size: 14.5)
        label.textAlignment = .right
        return label
    }()
    

    
     lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .gray
        return button
    }()
    
    
     let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        view.isHidden = true
        return view
    }()
    
    
    private func setUpViews() {
        backgroundColor = .white
        addSubview(nameOfInfoLabel)
        addSubview(valueOfInfoLabel)
        addSubview(rightArrowButton)
        addSubview(lineSeperatorView)
        
       
        nameOfInfoLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: valueOfInfoLabel.leadingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 50))

        
        valueOfInfoLabel.anchor(top: topAnchor, leading: nameOfInfoLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 38))

        
        rightArrowButton.constrainToRight(paddingRight: -18)
        rightArrowButton.centerYAnchor.constraint(equalTo: valueOfInfoLabel.centerYAnchor).isActive = true
        
        lineSeperatorView.anchor(top: nil, leading: nameOfInfoLabel.leadingAnchor, bottom: bottomAnchor, trailing: rightArrowButton.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 0, height: 0.8))
    }
}
