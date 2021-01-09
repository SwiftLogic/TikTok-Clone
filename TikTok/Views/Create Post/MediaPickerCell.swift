//
//  MediaPickerCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/26/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
protocol MediaPickerCellDelegate: class {
    func didSelectMediaCell(asset: PHAsset, cell: MediaPickerCell)
    
}
class MediaPickerCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    weak var mediaPickerCellDelegate: MediaPickerCellDelegate?
    
    var phAsset: PHAsset? {
        didSet {
            videoDurationLabel.isHidden = phAsset?.mediaType == .image ? true : false
        }
    }

    
     let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       imageView.isUserInteractionEnabled = true
       return imageView
   }()
       
    
   
        let videoDurationLabel: UILabel = {
           let label = UILabel()
           label.textColor = .white
           label.font = UIFont.systemFont(ofSize: 12)
           return label
       }()
       
       
        lazy var selectedCheckIconImageView: UIImageView = {
           let imageview = UIImageView()
           imageview.clipsToBounds = true
           imageview.contentMode = .scaleAspectFill
           imageview.translatesAutoresizingMaskIntoConstraints = false
           imageview.layer.cornerRadius = 20 / 2
           imageview.image = unselectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
           imageview.tintColor = .white
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapCheckMark))
           imageview.isUserInteractionEnabled = true
           imageview.addGestureRecognizer(tapGesture)
           return imageview
       }()
    
    
    
    let selectedCountLabel: UILabel = {
          let label = UILabel()
          label.textColor = .white
          label.font = UIFont.systemFont(ofSize: 12)
          return label
      }()
      
    
    
    //MARK: - Handlers
    
     func setUpViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.addSubview(videoDurationLabel)
        
        videoDurationLabel.constrainToBottom(paddingBottom: -5)
        videoDurationLabel.constrainToRight(paddingRight: -5)
        
        
        imageView.addSubview(selectedCheckIconImageView)
        selectedCheckIconImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 7))
        selectedCheckIconImageView.constrainWidth(constant: 20)
        selectedCheckIconImageView.constrainHeight(constant: 20)
        
        
//        selectedCheckIconImageView.addSubview(selectedCountLabel)
//        selectedCountLabel.centerInSuperview()

        
        
    }
    
    
    @objc func handleTapCheckMark() {
        if let asset = phAsset {
            mediaPickerCellDelegate?.didSelectMediaCell(asset: asset, cell: self)
        }
    }
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
