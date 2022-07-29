//
//  BookmarkedHashtagsCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/6/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
private let cellId = "BookmarkedHashtagsCellIdentifier"
class BookmarkedHashtagsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    static let cellDimen: CGFloat = 65//80
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview(padding: .init(top: 30, left: 0, bottom: 38, right: 0))
        collectionView.contentInset = .init(top: 15, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 15, left: 0, bottom: 0, right: 0)
        collectionView.register(FavoriteHashtagsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    //MARK: - Target Selectors
}


//MARK: - CollectionView Delegate & DataSource

extension BookmarkedHashtagsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteHashtagsCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        return .init(width: width, height: BookmarkedHashtagsCell.cellDimen)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
