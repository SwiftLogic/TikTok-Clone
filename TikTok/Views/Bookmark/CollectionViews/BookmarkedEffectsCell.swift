//
//  BookmarkedEffectsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/6/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class BookmarkedEffectsCell: BookmarkedSoundsCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    
    
    
    
    //MARK: - Handlers
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteSoundsCell
        cell.setImageForButton(imageName: "video")
        return cell
    }
    
    //MARK: - Target Selectors
}
