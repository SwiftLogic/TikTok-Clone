//
//  PreviewSelectedAssetCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 12/3/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
protocol PreviewSelectedAssetCellDelegate: AnyObject {
    func didTapCancelButton(asset: PHAsset)
}
class PreviewSelectedAssetCell: MediaPickerCell {
    
    weak var delegate : PreviewSelectedAssetCellDelegate?
    
     lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleDidTapCancelButton), for: .allTouchEvents)
        return button
    }()

    
    let playerView: UIView = {
          let view = UIView()
          return view
      }()
         
    
    override func setUpViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
        
        imageView.addSubview(playerView)
        playerView.fillSuperview()
        
        playerView.insertSubview(backButton, at: 1)
        backButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 10, bottom: 0, right: 0), size: .init(width: 20, height: 20))



        playerView.insertSubview(selectedCheckIconImageView, at: 1)
       selectedCheckIconImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 10), size: .init(width: 20, height: 20))
//        selectedCheckIconImageView.tintColor = .gray
        
        selectedCheckIconImageView.image = selectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
        selectedCheckIconImageView.backgroundColor = .white
        selectedCheckIconImageView.tintColor = tikTokRed
        selectedCheckIconImageView.layer.borderWidth = 1
        selectedCheckIconImageView.layer.borderColor = UIColor.white.cgColor
        
        
        
        playerView.insertSubview(selectedCountLabel, at: 1)
        selectedCountLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedCountLabel.text = "Selected"
        selectedCountLabel.font = defaultFont(size: 14.5)
        selectedCountLabel.centerYAnchor.constraint(equalTo: selectedCheckIconImageView.centerYAnchor).isActive = true
        selectedCountLabel.trailingAnchor.constraint(equalTo: selectedCheckIconImageView.leadingAnchor, constant: -8).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapCancelButton))
        addGestureRecognizer(tapGesture)
               
    }
    
    
    @objc fileprivate func handleDidTapCancelButton() {
        if let asset = phAsset {
            delegate?.didTapCancelButton(asset: asset)
        }
    }
}
