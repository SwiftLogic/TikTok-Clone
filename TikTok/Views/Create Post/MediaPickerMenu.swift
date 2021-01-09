//
//  MediaPickerMenu.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/25/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
class MediaPickerMenu: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    //MARK: - Init

    
    //MARK: - Properties
    var horizontalBarLeftConstraint: NSLayoutConstraint?
    weak var mediaPickerVC: MediaPickerVC?

    fileprivate let menuTitles = ["Videos", "Image"]
    fileprivate let cellReuseId = "TikTokcloneID"
     lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    
    let horizontalBarView : UIView = {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .black
        horizontalBarView.clipsToBounds = true
        horizontalBarView.layer.cornerRadius = 0//2
        return horizontalBarView
    }()
    
    
    let lineSeperatorView : UIView = {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = baseWhiteColor
        return horizontalBarView
    }()
    
    
    //MARK: - Handlers

    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(MediaMenuCell.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView.selectItem(at: [0, 0], animated: false, scrollPosition: [])
        setUpHorizontalBarView()
    }
    
    
    fileprivate func setUpHorizontalBarView() {
        addSubview(horizontalBarView)
        horizontalBarView.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .zero, size: .init(width: 0, height: 2.5))
        
        horizontalBarLeftConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: leadingAnchor)
        horizontalBarLeftConstraint?.isActive = true
        
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2).isActive = true
        
        
        addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: -0.3, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))


    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


 //MARK: - CollectionView Delegate
extension MediaPickerMenu: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! MediaMenuCell
        cell.menuLabel.text = menuTitles[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 2
        return CGSize(width: width, height: frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mediaPickerVC?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
}
