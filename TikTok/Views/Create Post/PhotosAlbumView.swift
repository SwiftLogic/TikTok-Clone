//
//  PhotosAlbumView.swift
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
protocol PhotosAlbumViewDelegate: class {
    func didTapCustomAlbum(albumName: String)
    func didTapRecentsAlbum(albumName: String)
    func didTapPanoramasPhotosAlbum(albumName: String)
    func didTapVideosAlbum(albumName: String)
    func didTapFavoritedAlbum(albumName: String)
    func didTapTimeLapseAlbum(albumName: String)
    func didTapBurstsAlbum(albumName: String)
    func didTapSlomoAlbum(albumName: String)
    func albumVCViewWillDisAppear()
}
class PhotosAlbumView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        handleLoadDataIntoView()
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: PhotosAlbumViewDelegate?
    
    var listOfsmartAlbumSubtypesToBeFetched:[PHAssetCollectionSubtype] = [.smartAlbumUserLibrary, .smartAlbumPanoramas, .smartAlbumVideos, .smartAlbumFavorites, .smartAlbumTimelapses, .smartAlbumBursts, .smartAlbumSlomoVideos]
    
    var smartAlbums: [PHAssetCollection] = [] {didSet {collectionView.reloadData()}}
    
    var customAlbumList = [PHAssetCollection](){didSet {collectionView.reloadData()}}
    
    var customAlbumMediaCount = [Int]()
    var smartAlbumMediaCount = [Int]()

    let userCreatedAlbumLists = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    
    fileprivate let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        return view
    }()
    
    
    fileprivate let smartAlbumCellReuseId = "smartAlbumCellReuseId"
    fileprivate let userCreatedAlbumCellReuseId = "userCreatedAlbumCellReuseId"

     lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    
    //MARK: - Handlers
    @objc fileprivate func handleLoadDataIntoView() {
           fetchUserCreatedAlbums()
           smartAlbums = fetchSmartCollections(with: .smartAlbum, subtypes: listOfsmartAlbumSubtypesToBeFetched)
           setUpViews()
       }
    
    
    fileprivate func setUpViews() {
        addSubview(lineSeperatorView)
        
        addSubview(collectionView)
        
        lineSeperatorView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero, size: .init(width: 0, height: 0.5))
        
        collectionView.fillSuperview(padding: .init(top: 0.5, left: 0, bottom: 0, right: 0))
        
        
        collectionView.register(PhotoAlbumCell.self, forCellWithReuseIdentifier: smartAlbumCellReuseId)
        collectionView.register(PhotoAlbumCell.self, forCellWithReuseIdentifier: userCreatedAlbumCellReuseId)


    }
    
    
    
    
    
    //MARK: - Photos framework
    // get the assets in a collection
    private func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)//NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        let albumAsset = PHAsset.fetchAssets(in: collection, options: photosOptions)
        return albumAsset
    }
    
    
    private func fetchSmartCollections(with: PHAssetCollectionType, subtypes: [PHAssetCollectionSubtype]) -> [PHAssetCollection] {
        var collections:[PHAssetCollection] = []
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        
        for subtype in subtypes {
            if let collection = PHAssetCollection.fetchAssetCollections(with: with, subtype: subtype, options: options).firstObject, collection.photosCount > 0 { // .photosCount comes from extesion
                collections.append(collection)
                smartAlbumMediaCount.append(collection.photosCount)
                self.collectionView.reloadData()
            }
        }
        
        return collections
    }
    
    
    
    private func fetchUserCreatedAlbums() {
        userCreatedAlbumLists.enumerateObjects { [weak self](coll, _, _) in
            guard let self = self else {return}
            let photoInAlbum = self.getAssets(fromCollection: coll)
            let albumContentCount = photoInAlbum.count
            
            if albumContentCount > 0 {
                self.customAlbumList.append(coll)
                self.customAlbumMediaCount.append(albumContentCount)
                self.collectionView.reloadData()

            }
            
        }
    }
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




 //MARK: - CollectionView Delegate
extension PhotosAlbumView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smartAlbumCellReuseId, for: indexPath) as! PhotoAlbumCell
            cell.pHCollection = smartAlbums[indexPath.item]
            cell.albumMediaCount = smartAlbumMediaCount[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCreatedAlbumCellReuseId, for: indexPath) as! PhotoAlbumCell
            cell.pHCollection = customAlbumList[indexPath.item]
            cell.albumMediaCount = customAlbumMediaCount[indexPath.row]
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoAlbumCell, let pHCollectionUnwrapped = cell.pHCollection else {return}
        guard let albumName = pHCollectionUnwrapped.localizedTitle  else {return}
        
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                delegate?.didTapRecentsAlbum(albumName: albumName)
            } else if indexPath.item == 1 {
                delegate?.didTapPanoramasPhotosAlbum(albumName: albumName)

            } else if indexPath.item == 2 {
                delegate?.didTapVideosAlbum(albumName: albumName)

            } else if indexPath.item == 3 {
                delegate?.didTapFavoritedAlbum(albumName: albumName)

            } else if indexPath.item == 4 {
                delegate?.didTapTimeLapseAlbum(albumName: albumName)

            } else if indexPath.item == 5 {
                delegate?.didTapBurstsAlbum(albumName: albumName)

            } else {
                delegate?.didTapSlomoAlbum(albumName: albumName)
            }
            
        } else if indexPath.section == 1 {
            delegate?.didTapCustomAlbum(albumName: albumName)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        return CGSize(width: width, height: 90)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? smartAlbums.count : customAlbumList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}



extension PHAssetCollection {
    @objc var photosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
}
