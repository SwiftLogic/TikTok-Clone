//
//  SelectedAssetCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/29/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
protocol SelectedAssetCellDelegate: class {
    func didTapRemoveSelected(asset: PHAsset)
}
class SelectedAssetCell: UICollectionViewCell {
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        handleSetUpViews()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapCancelButton))
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    weak var delegate: SelectedAssetCellDelegate?
    
    var phAsset: PHAsset? {
        didSet {
            videoDurationLabel.isHidden = phAsset?.mediaType == .image ? true : false
            guard let asset = phAsset else {return}
            let width = (frame.width)
            let size = CGSize(width: width, height: width)
            imageView.image = getAssetThumbnail(asset: asset, size: size)
            let videoLegthInString = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
            videoDurationLabel.text = videoLegthInString
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    

    fileprivate let videoDurationLabel: UILabel = {
          let label = UILabel()
          label.textColor = .white
          label.font = UIFont.systemFont(ofSize: 12)
          return label
      }()
    
    
    fileprivate lazy var cancelSuperView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapCancelButton))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //MARK: - Handlers

    fileprivate func handleSetUpViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        
        imageView.addSubview(cancelSuperView)
        
        cancelSuperView.constrainToTop(paddingTop: 0)
        cancelSuperView.constrainToRight(paddingRight: 0)
        cancelSuperView.constrainHeight(constant: 19)
        cancelSuperView.constrainWidth(constant: 19)
        
        cancelSuperView.addSubview(cancelButton)
        cancelButton.centerInSuperview(size: .init(width: 8, height: 8))
        
        imageView.addSubview(videoDurationLabel)
        videoDurationLabel.centerXInSuperview()
        videoDurationLabel.constrainToBottom(paddingBottom: -3)
        
        
        

    }

    
    @objc func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage? {
         let thumbnailImage = PHLibraryAPI.shared.getAssetThumbnail(asset: asset, size: size)
        return thumbnailImage
    }
    
    
    
    @objc fileprivate func handleDidTapCancelButton() {
        if let asset = phAsset {
            delegate?.didTapRemoveSelected(asset: asset)
            print("didTapRemoveSelected in SelectedAssetCell")
        }
    }
}
