//
//  NotificationTypeCell.swift
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
class NotificationTypeCell: UITableViewCell {
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    
    
    //MARK: - Properties
    var notificationType: NotificationType! {
        didSet {
            iconImageView.image = UIImage(named: notificationType.imageName)?.withRenderingMode(.alwaysTemplate)
            titleLabel.text = notificationType.title
        }
    }
    
    
    
    fileprivate let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()
    
    
    
    fileprivate let checkMarkIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "doneCheck")
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.red
        return imageView
    }()
    
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = defaultFont(size: 14.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(checkMarkIconImageView)
        
        iconImageView.centerYInSuperview()
        iconImageView.constrainToLeft(paddingLeft: 23)
        iconImageView.constrainWidth(constant: 17)
        iconImageView.constrainHeight(constant: 17)
        
        titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 1.4).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15).isActive = true
        
        
        checkMarkIconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0).isActive = true
        checkMarkIconImageView.constrainToRight(paddingRight: -23)
        checkMarkIconImageView.constrainWidth(constant: 17)
        checkMarkIconImageView.constrainHeight(constant: 17)
    }
    
    
    
    func handleCellSelection(cellIsSelected: Bool) {
        iconImageView.tintColor = cellIsSelected == true ? .black : .gray
        titleLabel.textColor = cellIsSelected == true ? .black : .gray
        checkMarkIconImageView.isHidden = cellIsSelected == true ? false : true
     }
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
