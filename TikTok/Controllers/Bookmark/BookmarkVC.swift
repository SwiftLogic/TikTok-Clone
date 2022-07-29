//
//  BookmarkVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/5/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
fileprivate let videosCellReuseId = "videosCellReuseId"
fileprivate let hashtagsCellId = "hashtagsCellId"
fileprivate let soundsCellId = "soundsCellId"
fileprivate let effectsCellId = "effectsCellId"
fileprivate let productsCellId = "productsCellId"
class BookmarkVC: UIViewController {
    //MARK: - Init
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
       
    }
    
    
    //MARK: - Properties
    fileprivate let filterMenuViewHeight: CGFloat = 45
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    fileprivate let menuTitles = ["Videos", "Hashtags", "Sounds", "Effects", "Products"]
    fileprivate lazy var filterView: FilterMenuView = {
        let view = FilterMenuView(menuTitles: menuTitles)
        view.delegate = self
        return view
    }()
    
    
    
    //MARK: - Handlers
    private func setUpViews() {
        navigationItem.title = "Favorites"
        view.backgroundColor = .white
        view.addSubview(filterView)
        filterView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: filterMenuViewHeight))
        
        view.addSubview(collectionView)
        collectionView.anchor(top: filterView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        registerCells()


    }
    
    
    private func dequeuedReusableCell(withCellId cellId: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    private func registerCells() {
        collectionView.register(BookmarkedVideosCell.self, forCellWithReuseIdentifier: videosCellReuseId)
        collectionView.register(BookmarkedHashtagsCell.self, forCellWithReuseIdentifier: hashtagsCellId)
        collectionView.register(BookmarkedSoundsCell.self, forCellWithReuseIdentifier: soundsCellId)
        collectionView.register(BookmarkedEffectsCell.self, forCellWithReuseIdentifier: effectsCellId)
        collectionView.register(BookmarkedProductsCell.self, forCellWithReuseIdentifier: productsCellId)

    }
    
    //MARK: - Target Selectors
}



//MARK: - CollectionView Delegate and Protocols
extension BookmarkVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0: return dequeuedReusableCell(withCellId: videosCellReuseId, indexPath: indexPath) as! BookmarkedVideosCell
        case 1: return dequeuedReusableCell(withCellId: hashtagsCellId, indexPath: indexPath) as! BookmarkedHashtagsCell
        case 2: return dequeuedReusableCell(withCellId: soundsCellId, indexPath: indexPath) as! BookmarkedSoundsCell
        case 3: return dequeuedReusableCell(withCellId: effectsCellId, indexPath: indexPath) as! BookmarkedEffectsCell
        case 4: return dequeuedReusableCell(withCellId: productsCellId, indexPath: indexPath) as! BookmarkedProductsCell
        default: return dequeuedReusableCell(withCellId: videosCellReuseId, indexPath: indexPath) as! BookmarkedVideosCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height - filterMenuViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        filterView.horizontalBarLeftConstraint?.constant = scrollView.contentOffset.x  / CGFloat(menuTitles.count) //+ FilterMenuView.lineSpacing
        
    }
        
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        filterView.handleSelectItem(atIndex: Int(index), animated: true)
    }
}

//MARK: - FilterMenuViewDelegate
extension BookmarkVC: FilterMenuViewDelegate {
    func scrollToMenu(atIndexPath indexPath: IndexPath) {
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
    }
    
}
