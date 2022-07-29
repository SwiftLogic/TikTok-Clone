//
//  SoundsVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
fileprivate let cellReuseId = "SoundsVCcellReuseId"
fileprivate let headerReuseId = "SoundsVCheaderReuseId"

class SoundsVC: UICollectionViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavItems()
        setUpViews()
        setUpCollectionView()
    }
    
    
    //MARK: - Properties
    
    //MARK: - UI Requirements Searchbar -> a vertical collectionview -> with a header that contains a uipagecontroll & its embedded horizontal collectionView, and a filterMenuBar to seperate discover from favorites, the parent collectionview cells contain an embedded horizontal collectionview each sections as follows section 0 is recommended, section 1 is playlist and it contains a different style of horizontal cells
    
    
    static let horizontalSpacings: CGFloat = 15
    fileprivate lazy var searchBar: UISearchBar = {
         let sb = UISearchBar()
         sb.placeholder = "Search"
         sb.searchBarStyle = .minimal
         sb.isTranslucent = true
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
         textFieldInsideSearchBar?.layer.cornerRadius = 2
         textFieldInsideSearchBar?.borderStyle = .none
         return sb
     }()
    
    
    fileprivate let topwhiteSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    //MARK: - Handlers
    fileprivate func setUpNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: cancelIcon, style: .plain, target: self, action: nil)
        navigationItem.title = "Sounds"
        navigationController?.setNavigationBarBorderColor(.clear) //removes navline
    }
    
    
    fileprivate func setUpViews() {
        view.addSubview(searchBar)
        view.addSubview(topwhiteSpacerView)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: SoundsVC.horizontalSpacings - 8, bottom: 0, right: SoundsVC.horizontalSpacings - 8), size: .init(width: 0, height: 40))
        
        topwhiteSpacerView.anchor(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 10))
        view.addSubview(collectionView)
        collectionView.anchor(top: topwhiteSpacerView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func setUpCollectionView() {
        collectionView.register(SoundsCell.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView.register(SoundsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseId)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false 
    }
}


//MARK: - CollectionView Protocols
extension SoundsVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! SoundsCell
        if indexPath.item == 11 {
            //last cell
            cell.lineSeperatorView.isHidden = true
        } else {
            cell.lineSeperatorView.isHidden = false

        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 313.5//view.frame.height / 2
        return .init(width: view.frame.width, height: height)
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseId, for: indexPath) as! SoundsHeader
//        header.backgroundColor = .red
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 165)
    }
}
