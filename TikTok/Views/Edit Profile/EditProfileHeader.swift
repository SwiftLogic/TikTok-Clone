//
//  EditProfileHeader.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/1/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class EditProfileHeader: UICollectionViewCell, EditProfileVCDelegate {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    fileprivate let profileImageDimen: CGFloat = 100
    var didTapChangeProfilePhoto: (() -> Void)?
    var user: User? {
        didSet {
            guard let user = user, let url = URL(string: user.profileImageUrl) else {return}
            profileImageView.kf.setImage(with: url)
        }
    }
    
    fileprivate lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = baseWhiteColor
        imageView.layer.cornerRadius = profileImageDimen / 2
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapChangeProfilePhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.4
        imageView.layer.borderColor = baseWhiteColor.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    fileprivate lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = cameraIcon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapChangeProfilePhoto))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    
    fileprivate lazy var changeProfilePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change photo", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = tikTokFont(size: 14.2)
        button.addTarget(self, action: #selector(handleDidTapChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(changeProfilePhotoButton)
        profileImageView.addSubview(cameraImageView)
        
        profileImageView.constrainToTop(paddingTop: 30)
        profileImageView.constrainHeight(constant: profileImageDimen)
        profileImageView.constrainWidth(constant: profileImageDimen)
        profileImageView.centerXInSuperview()
        
        changeProfilePhotoButton.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        changeProfilePhotoButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        
        cameraImageView.centerInSuperview(size: .init(width: 30, height: 30))
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func handleDidTapChangeProfilePhoto() {
        didTapChangeProfilePhoto?()
    }
    
    
    
    //MARK: EditProfileVC Delegate
    func didFinishPickingImage(image: UIImage) {
        profileImageView.image = image
    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



