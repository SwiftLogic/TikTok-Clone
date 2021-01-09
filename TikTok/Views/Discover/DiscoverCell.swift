//
//  DiscoverCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 10/12/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
fileprivate let cellReuseId = "DiscoverCellcellReuseId"
class DiscoverCell: UICollectionViewCell {
    //MARK: - View LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        handleSetUpViews()
    }
    
    
    //MARK: - Properties
    fileprivate let hashtahImageViewDimention: CGFloat = 35
    fileprivate lazy var hashtahImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = hashtahImageViewDimention / 2
        imageView.backgroundColor = .red
        return imageView
    }()

    
    
    fileprivate let hashtagTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "IndigeousPride"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    fileprivate let trendingHashtagLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.textColor = .gray
        return label
    }()
    
    
    
    fileprivate let postCountLabel: UILabel = {
        let label = UILabel()
        label.text = "230.4M >"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = baseWhiteColor
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    fileprivate let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    //MARK: - Handlers
    
    func handleSetUpViews() {
        [hashtahImageView, hashtagTitleLabel, trendingHashtagLabel, postCountLabel, collectionView, lineSeperatorView].forEach { (view) in
            addSubview(view)
        }
        
        hashtahImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: hashtahImageViewDimention, height: hashtahImageViewDimention))
        
        hashtagTitleLabel.anchor(top: hashtahImageView.topAnchor, leading: hashtahImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 1, left: 5, bottom: 0, right: 0))
        
        trendingHashtagLabel.anchor(top: hashtagTitleLabel.bottomAnchor, leading: hashtagTitleLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0))
        
        postCountLabel.anchor(top: hashtagTitleLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 12), size: .init(width: 70, height: 20))
        
        
        collectionView.anchor(top: trendingHashtagLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 15, right: 0))
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
        
        lineSeperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 0.4))
        
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - CollectionView Delegates

extension DiscoverCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 3.5
        return .init(width: width, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
}
