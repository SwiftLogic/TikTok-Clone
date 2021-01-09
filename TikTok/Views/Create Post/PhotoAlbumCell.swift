//
//  PhotoAlbumCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/27/20.
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
class PhotoAlbumCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    
    
    
    var pHCollection: PHCollection? {
           didSet {
               guard let pHCollectionUnwrapped = pHCollection else {return}
               //PHImageManagerMaximumSize returns nill at times so in that case we use self.frame.size as targetSize
               PHLibraryAPI.shared.fetchAlbumThumbnail(collection: pHCollectionUnwrapped, targetSize: PHImageManagerMaximumSize) { [weak self] (image) in
                   
                   //initial attempt to grab image with targetSize of PHImageManagerMaximumSize
                   guard let self = self else {return}
                   if let imageUnwrapped = image {
                       self.imageView.image = imageUnwrapped
                   } else {
                       //final attempt to grab image with targetSize of self.frame.size
                       PHLibraryAPI.shared.fetchAlbumThumbnail(collection: pHCollectionUnwrapped, targetSize: self.frame.size, completion: { [weak self] (imageRetrieve) in
                           guard let self = self else {return}
                           self.imageView.image = imageRetrieve
                       })
                   }
               }
           }
       }
       
       
       var albumMediaCount: Int?{
           didSet {
               guard let pHCollectionUnwrapped = pHCollection else {return}
               guard let numberOfPhotosInalbum = albumMediaCount else {return}
               let titleString = "\(pHCollectionUnwrapped.localizedTitle ?? "")\n"
               let subTitleString = "\(numberOfPhotosInalbum.formatUsingAbbrevation())"
               let attributedText = setupAttributedTextWithFonts(titleString: titleString, subTitleString: subTitleString, attributedTextColor: .gray, mainColor: .black, mainfont: defaultFont(size: 14), subFont: UIFont.systemFont(ofSize: 12.5))
               albumNameLabel.attributedText = attributedText
               
           }
       }
    
    
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
     let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(imageView)
        addSubview(albumNameLabel)
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 5, left: 15, bottom: 5, right: 0), size: .init(width: 70, height: 0))
                
        albumNameLabel.anchor(top: imageView.topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 23, left: 8, bottom: 0, right: 0))
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
