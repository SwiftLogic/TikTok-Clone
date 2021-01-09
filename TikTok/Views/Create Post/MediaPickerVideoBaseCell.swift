//
//  MediaPickerVideoBaseCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/28/20.
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
class MediaPickerVideoBaseCell: MediaPickerBaseCell {
    
    //MARK: - Init
  
    
    
    
    
    //MARK: - Properties
   
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! MediaPickerCell
        let asset = videoAssets[indexPath.item]
        let width = (frame.width) / 2.8
        let size = CGSize(width: width, height: width)
        cell.imageView.image = getAssetThumbnail(asset: asset, size: size)
        cell.phAsset = asset
        let videoLegthInString = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
        cell.videoDurationLabel.text = videoLegthInString
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoAssets.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return videoAssets.isEmpty == true ? CGSize(width: frame.width, height: frame.width) : .zero
       }
    
   
}
