//
//  DiscoverVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 10/12/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
fileprivate let cellReuseIdentifier = "cellReuseIdentifier"
fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
class DiscoverVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        handleSetUpNavItems()
    }
    
    
    //MARK: - Properties
    
   fileprivate lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.searchBarStyle = .prominent
        sb.isTranslucent = false
        var textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.rgb(red: 237, green: 237, blue: 238)
        sb.barTintColor = .white
        sb.tintColor = .lightGray
        sb.keyboardAppearance = .light
    
        let glassIconView = textFieldInsideSearchBar?.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = .black
    
//        sb.setLeftImage(magnifyIconInsideSearchbar!.withRenderingMode(.alwaysOriginal), with: 8, tintColor: .black)
        var cancelButton = sb.value(forKey: "cancelButton") as? UIButton
        cancelButton?.setTitleColor(.black, for: .normal)
        textFieldInsideSearchBar?.clipsToBounds = true
        textFieldInsideSearchBar?.layer.cornerRadius = 4
        textFieldInsideSearchBar?.borderStyle = .none
        return sb
    }()

    
    
    fileprivate let barCodeButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        let normalImage = UIImage(systemName: "plus.viewfinder", withConfiguration: symbolConfig)!
        button.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    fileprivate let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpCollectionView() {
        collectionView.register(DiscoverCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(DiscoverHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    
    fileprivate func handleSetUpNavItems() {
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.isUserInteractionEnabled = true
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .blackTranslucent
        navBar.addSubview(coverView)
        coverView.addSubview(barCodeButton)
        coverView.addSubview(searchBar)
        
        coverView.fillSuperview()
        barCodeButton.constrainToRight(paddingRight: -15)
        barCodeButton.centerYInSuperview()
                
        searchBar.anchor(top: coverView.topAnchor, leading: coverView.leadingAnchor, bottom: coverView.bottomAnchor, trailing: barCodeButton.leadingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 15))
              
        
    }
    
    
    
    //MARK: - CollectionView Protocols
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! DiscoverCell
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 215)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! DiscoverHeader
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}
