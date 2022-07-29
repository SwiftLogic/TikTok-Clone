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
    func didSelect(asset: PHAsset, cell: PreviewSelectedAssetCell)
}
class PreviewSelectedAssetCell: MediaPickerCell {
    
    weak var delegate : PreviewSelectedAssetCellDelegate?
    
     lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)!
        button.setImage(backImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleDidTapCancelButton), for: .allTouchEvents)
        return button
    }()

    
    let playerView: UIView = {
          let view = UIView()
          return view
      }()
    
    
    lazy var selectMediaTapView: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapSelect))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
         
   
    
    override func setUpViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
        
        imageView.addSubview(playerView)
        playerView.fillSuperview()
        
        playerView.insertSubview(backButton, at: 1)
        backButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 10, bottom: 0, right: 0), size: .init(width: 20, height: 20))



        playerView.insertSubview(selectedCheckIconImageView, at: 1)
       selectedCheckIconImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 10), size: .init(width: 20, height: 20))
        selectedCheckIconImageView.isUserInteractionEnabled = false
        selectedCountLabel.isUserInteractionEnabled = false
        
        playerView.insertSubview(selectedCountLabel, at: 1)
        selectedCountLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedCountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        selectedCountLabel.centerYAnchor.constraint(equalTo: selectedCheckIconImageView.centerYAnchor).isActive = true
        selectedCountLabel.trailingAnchor.constraint(equalTo: selectedCheckIconImageView.leadingAnchor, constant: -8).isActive = true
        
        
        playerView.insertSubview(selectMediaTapView, at: 1)
        selectMediaTapView.anchor(top: nil, leading: selectedCountLabel.leadingAnchor, bottom: nil, trailing: selectedCheckIconImageView.trailingAnchor, padding: .init(top: 0, left: -10, bottom: 0, right: -10), size: .init(width: 0, height: 50))
        selectMediaTapView.centerYAnchor.constraint(equalTo: selectedCheckIconImageView.centerYAnchor).isActive = true


        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapCancelButton))
        addGestureRecognizer(tapGesture)
               
    }
    
    
    @objc fileprivate func handleDidTapCancelButton() {
        if let asset = phAsset {
            delegate?.didTapCancelButton(asset: asset)
        }
    }
    
    
    @objc fileprivate func handleDidTapSelect() {
        if let asset = phAsset {
            delegate?.didSelect(asset: asset, cell: self)
        }
    }
}
