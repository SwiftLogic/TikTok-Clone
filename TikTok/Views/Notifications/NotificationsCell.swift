//
//  NotificationsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 10/10/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  TableViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class NotificationsCell: UITableViewCell {
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    
    
    //MARK: - Properties
    
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 / 2
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
    }()
    
    
    fileprivate let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
    }()
    
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "i.got.stolen.memes"
        return label
    }()
    
    
    fileprivate let notificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.textColor = .lightGray
        return label
    }()
    
    
    fileprivate let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = baseWhiteColor.cgColor//UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.clipsToBounds = true
        button.layer.cornerRadius = 1.5
        return button
    }()
    
    
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(notificationLabel)
//        addSubview(postImageView)
//        addSubview(followButton)
        

        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        profileImageView.centerYInSuperview()
        
        usernameLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 6.5, left: 8, bottom: 0, right: 0))
        
        notificationLabel.anchor(top: usernameLabel.bottomAnchor, leading: usernameLabel.leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 1.3, left: 0, bottom: 0, right: 0))
        
//        followButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: spacing), size: .init(width: 90, height: 28))
//        followButton.centerYInSuperview()
        
//        postImageView.anchor(top: profileImageView.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: spacing), size: .init(width: 45, height: 65)) //height was 65 init
        
        
        let profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/imessage-f5d42.appspot.com/o/message_images%2Ffd02304e-6875-4c6a-a75c-d387f453077d?alt=media&token=b5d716eb-dd6e-4349-8a64-b246a820410e"

        guard let url = URL(string: profileImageUrl) else {return}
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url)
        
        
        postImageView.image = UIImage(named: "sam")

        

    }
    
    
    func setUpFollowButton() {
        let spacing = frame.width * 0.05
        addSubview(followButton)
        followButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: spacing), size: .init(width: 90, height: 28))
        followButton.centerYInSuperview()
        notificationLabel.text = "started following. 4w"
    }
    
    
    func setUpPostImageView() {
        let spacing = frame.width * 0.05
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: spacing), size: .init(width: 45, height: 55)) //height was 65 init
        notificationLabel.text = "liked your video. 2m"
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
