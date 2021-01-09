//
//  MediaPickerVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/25/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
fileprivate let videosCellReuseIdentifier = "videosCellReuseIdentifier"
fileprivate let photosCellReuseIdentifier = "photosCellReuseIdentifier"
fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
protocol MediaPickerVCDelegate: class {
    func didChangeAlbum(album: [PHAsset])
    func isLoadingNewAlbumIntoDataSource()
    func didTapRemoveSelected(asset: PHAsset)
}


protocol DidSelectMediaDelegate: class {
    func didSelectMedia(asset: PHAsset)
    func didDeSelectMedia(asset: PHAsset)

}


protocol MediaPickerWasClosedDelegate: class {
    func didTapCloseMediaPicker()
}

class MediaPickerVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        getPhotosAndVideosFromPhotosFrameWork()
        handleSetUpNavItem()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mediaPickerWasClosedDelegate?.didTapCloseMediaPicker()

    }
   
    
    
    //MARK: - Properties
    weak var delegate: MediaPickerVCDelegate?
    weak var didSelectMediaDelegate: DidSelectMediaDelegate?
    weak var mediaPickerWasClosedDelegate: MediaPickerWasClosedDelegate?
    
    fileprivate lazy var menuBarView: MediaPickerMenu = {
        let view = MediaPickerMenu()
        view.mediaPickerVC = self
        return view
    }()
    
    
    fileprivate var navLabelTitle: String? {
        didSet {
            navTitleLabel.text = navLabelTitle
        }
    }
    
    
    fileprivate var currentIndex = 0 //where 0 = videos & 1 = images
    
    fileprivate var zooomingImageView: UIImageView?
    fileprivate var startingImageView: UIImageView?
    fileprivate var startingFrame: CGRect?
    fileprivate var previewSelectedAssetsView: PreviewSelectedAssetsView?

    
       var currentlySelectedAlnumAssets :[PHAsset] = []
       var favoritedAssets: [PHAsset] = []
       var videosAsset: [PHAsset] = []
       var imagesAsset: [PHAsset] = []
       var backedUpImageAssets: [PHAsset] = []
       var screenShotsAssets: [PHAsset] = []
       var livePhotosAssets: [PHAsset] = []
       var panoramaPhotosAssets: [PHAsset] = []
    
    
    fileprivate var videosCellDataSource: [PHAsset] = []
    fileprivate var imagesCellDataSource: [PHAsset] = []

    
    fileprivate lazy var navBarContainerView: UIView = {
        let navBarContainerView = UIView()
        navBarContainerView.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAlbumContainerViewVisibility))
        navBarContainerView.isUserInteractionEnabled = true
        navBarContainerView.addGestureRecognizer(tapGesture)
        return navBarContainerView
    }()

    fileprivate let navTitleLabel: UILabel = {
           let label = UILabel()
           label.text = "All photos"
           label.textColor = .black
           label.font = UIFont.boldSystemFont(ofSize: 16.5)
           label.textAlignment = .center
           label.isUserInteractionEnabled = false
           return label
       }()
       
       
       fileprivate let expandArrowIconImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.image = expandAlbumsIcon?.withRenderingMode(.alwaysOriginal)
           imageView.clipsToBounds = true
           return imageView
       }()
    
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(flipCameraIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleResetAlbum), for: .touchUpInside)
        return button
    }()
    
    
    
    fileprivate lazy var albumTranslation = -view.frame.height
    fileprivate var albumIsOpen = false
    fileprivate lazy var albumContainerView: PhotosAlbumView = {
        let albumContainerView = PhotosAlbumView()
        albumContainerView.transform = CGAffineTransform(translationX: 0, y: albumTranslation)
        albumContainerView.delegate = self
        return albumContainerView
    }()
    
    
    fileprivate lazy var bottomContainerView: SelectedAssetsView = {
        let selectedAssetsView = SelectedAssetsView()
        selectedAssetsView.delegate = self
        return selectedAssetsView
    }()
    
    //MARK: - Handlers
    fileprivate func setUpCollectionView() {
       view.addSubview(menuBarView)
       menuBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 40))
        
        
       
               
       view.addSubview(collectionView)
       collectionView.anchor(top: menuBarView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        collectionView.register(MediaPickerBaseCell.self, forCellWithReuseIdentifier: videosCellReuseIdentifier)
        collectionView.register(MediaPickerBaseCell.self, forCellWithReuseIdentifier: photosCellReuseIdentifier)

        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        view.addSubview(bottomContainerView)
        bottomContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))

        view.addSubview(albumContainerView)
        albumContainerView.anchor(top: menuBarView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
               
       
    }
    
    
    
    fileprivate func handleSetUpNavItem() {
        handleHide_ShowNavLine(navController: navigationController, showLine: false)
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.addSubview(navBarContainerView)
//        navBarContainerView.centerInSuperview(size: .init(width: 200, height: navBar.frame.height))
        navBarContainerView.centerInSuperview(size: .init(width: navBar.frame.width, height: navBar.frame.height))

        navBarContainerView.addSubview(navTitleLabel)
        navTitleLabel.centerInSuperview()
        navBarContainerView.addSubview(expandArrowIconImageView)
        expandArrowIconImageView.centerYAnchor.constraint(equalTo: navTitleLabel.centerYAnchor, constant: 0.5).isActive = true
        expandArrowIconImageView.leadingAnchor.constraint(equalTo: navTitleLabel.trailingAnchor, constant: 7).isActive = true
        expandArrowIconImageView.constrainHeight(constant: 13)
        expandArrowIconImageView.constrainWidth(constant: 13)
        
        navBar.addSubview(cancelButton)
        cancelButton.anchor(top: nil, leading: navBar.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        cancelButton.centerYInSuperview()
        
        
        navBar.addSubview(resetButton)
        resetButton.anchor(top: nil, leading: nil, bottom: nil, trailing: navBar.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 30, height: 30))
        resetButton.centerYInSuperview()
               
        
        
//        let navBarHeight = navBar.frame.height
//        view.addSubview(albumContainerView)
//        albumContainerView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//
     }
        
    
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc fileprivate func handleAlbumContainerViewVisibility() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[weak self] in
            guard let self = self else {return}
            if self.albumIsOpen == false {
                //show album
                self.albumContainerView.transform = .identity
                self.expandArrowIconImageView.handleRotate180(rotate: true)
            } else {
                //close album
                self.expandArrowIconImageView.handleRotate180(rotate: false)
                self.albumContainerView.transform = CGAffineTransform(translationX: 0, y: self.albumTranslation)
            }
        }) {[weak self] (completion) in
            guard let self = self else {return}
            self.albumIsOpen = !self.albumIsOpen
        }
    }
    
    
    //MARK: - CollectionView Protocols
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videosCellReuseIdentifier, for: indexPath) as! MediaPickerBaseCell
            cell.imageAndVideoAssets = videosCellDataSource
            cell.footerLabel.text = "Cannot find videos in gallery"
            delegate = cell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosCellReuseIdentifier, for: indexPath) as! MediaPickerBaseCell
            cell.imageAndVideoAssets = imagesCellDataSource
            cell.footerLabel.text = "No photos available"
            delegate = cell
            cell.delegate = self
            return cell
        }
        
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func scrollToMenuIndex(menuIndex: Int) {
           let indexPath = IndexPath(item: menuIndex, section: 0)
           collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
           currentIndex = menuIndex

       }
       
       
       
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           menuBarView.horizontalBarLeftConstraint?.constant = scrollView.contentOffset.x / 2
           
       }
       
       
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
           
           
           let index = targetContentOffset.pointee.x / view.frame.width
           
           let indexPath = IndexPath(item: Int(index), section: 0)
           currentIndex = Int(index)
           menuBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
           
           
       }
    
    
    
    

    @objc fileprivate func handleResetAlbum() {
        currentlySelectedAlnumAssets = backedUpImageAssets
        navLabelTitle = "All photos"
        handleFilterMediaTypeOutOf(mediaType: .image, album: currentlySelectedAlnumAssets) {[weak self] (filtertedImageAssets) in
            guard let self = self else {return}
            self.imagesCellDataSource = filtertedImageAssets ?? []
            self.collectionView.reloadData()
        }
        
        handleFilterMediaTypeOutOf(mediaType: .video, album: currentlySelectedAlnumAssets) {[weak self] (filtertedVideoAssets) in
            guard let self = self else {return}
            self.videosCellDataSource = filtertedVideoAssets ?? []
            self.collectionView.reloadData()
        }
    }
    
    
    
    fileprivate func handleScrollBaseCollectionViewTo(menuIndex: Int) {
        handleResetAlbum()
        scrollToMenuIndex(menuIndex: menuIndex)
        let indexPath = IndexPath(item: menuIndex, section: 0)
        menuBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        guard let cell = menuBarView.collectionView.cellForItem(at: indexPath) as? MediaMenuCell else {return}
        cell.isSelected = true
    }
    
    
     fileprivate func assetFetchOptions() -> PHFetchOptions {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let predicate =  NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
            fetchOptions.predicate = predicate
            return fetchOptions
            
        }
            
            
    @objc func getPhotosAndVideosFromPhotosFrameWork(){
        PHLibraryAPI.shared.getPhotosAndVideos(phFetchOptions: assetFetchOptions()) { [weak self] (assets, status) in
            guard let self = self, let imageAndVideoAssetsUnwrapped = assets else {return}

            
            for index in 0..<imageAndVideoAssetsUnwrapped.count {
                
                if imageAndVideoAssetsUnwrapped[index].isFavorite == true {
                    self.favoritedAssets.append(imageAndVideoAssetsUnwrapped[index])
                }


                if imageAndVideoAssetsUnwrapped[index].mediaType == .video {
                    self.videosAsset.append(imageAndVideoAssetsUnwrapped[index])
                }
                
                
                if imageAndVideoAssetsUnwrapped[index].mediaType == .image {
                    self.imagesAsset.append(imageAndVideoAssetsUnwrapped[index])
                }


                
                if imageAndVideoAssetsUnwrapped[index].mediaSubtypes == .photoScreenshot {
                    self.screenShotsAssets.append(imageAndVideoAssetsUnwrapped[index])
                }

                if imageAndVideoAssetsUnwrapped[index].mediaSubtypes == .photoLive {
                    self.livePhotosAssets.append(imageAndVideoAssetsUnwrapped[index])
                }
                

                //note we are not using pano yet maybe in the future i'll add it
                if imageAndVideoAssetsUnwrapped[index].mediaSubtypes == .photoPanorama {
                    self.panoramaPhotosAssets.append(imageAndVideoAssetsUnwrapped[index])
                }
                
                self.currentlySelectedAlnumAssets = imageAndVideoAssetsUnwrapped
                self.backedUpImageAssets = imageAndVideoAssetsUnwrapped

            }
            
   
            self.videosCellDataSource = self.videosAsset
            self.imagesCellDataSource = self.imagesAsset
            self.collectionView.reloadData()
        
            
        }

    }
    

    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}



//MARK: - PhotosAlbumViewDelegate
extension MediaPickerVC: PhotosAlbumViewDelegate {
    
    func didTapCustomAlbum(albumName: String) {
        handleAlbumContainerViewVisibility()
        delegate?.isLoadingNewAlbumIntoDataSource()
        PHLibraryAPI.shared.fetchSpecificUserAlbum(albumName: albumName, collectionType: .album, collectionSubType: .any) { [weak self] (assets) in
             guard let self = self else {return}
            let indexPath = IndexPath(item: 0, section: 0)
             self.collectionView?.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
             self.videosCellDataSource.removeAll()
             self.imagesCellDataSource.removeAll()
             self.navLabelTitle = albumName

             self.handleFilterMediaTypeOutOf(mediaType: .video, album: assets) {[weak self] (filteredAlbum) in
                 self?.videosCellDataSource = filteredAlbum ?? []
                 self?.delegate?.didChangeAlbum(album: filteredAlbum ?? [])
//                self?.delegate?.didChangeVideosAlbum(album: assets)
                 self?.collectionView.reloadData()
             }
            
             self.handleFilterMediaTypeOutOf(mediaType: .image, album: assets) {[weak self] (filteredAlbum) in
                self?.imagesCellDataSource = filteredAlbum ?? []
                self?.delegate?.didChangeAlbum(album: filteredAlbum ?? [])
//                self?.delegate?.didChangePhotosAlbum(album: assets)
                self?.collectionView.reloadData()
            }
                     
        }
    }
    
    
    func didTapRecentsAlbum(albumName: String) {
        handleFetchRefreshDataSource(albumName: albumName, collectionType: .smartAlbum, collectionSubType: .smartAlbumUserLibrary)
    }
    
    
    func didTapPanoramasPhotosAlbum(albumName: String) {
        handleFetchRefreshDataSource(albumName: albumName, collectionType: .smartAlbum, collectionSubType: .smartAlbumPanoramas)
    }
    
    
    func didTapVideosAlbum(albumName: String) {
        videosCellDataSource.removeAll()
        imagesCellDataSource.removeAll()
        videosCellDataSource = videosAsset
        navLabelTitle = albumName
        handleFilterMediaTypeOutOf(mediaType: .image, album: videosAsset) {[weak self] (filteredAlbum) in
            self?.imagesCellDataSource = filteredAlbum ?? []
            self?.collectionView.reloadData()
        }
        collectionView.reloadData()
        handleAlbumContainerViewVisibility()
    }
    
    
    
    func didTapFavoritedAlbum(albumName: String) {
        handleFetchRefreshDataSource(albumName: albumName, collectionType: .smartAlbum, collectionSubType: .smartAlbumFavorites)
    }
    
    func didTapTimeLapseAlbum(albumName: String) {
        handleFetchRefreshDataSource(albumName: albumName, collectionType: .smartAlbum, collectionSubType: .smartAlbumTimelapses)

    }
    
    func didTapBurstsAlbum(albumName: String) {
       handleFetchRefreshDataSource(albumName: albumName, collectionType: .smartAlbum, collectionSubType: .smartAlbumBursts)

    }
    
    
    func didTapSlomoAlbum(albumName: String) {
        handleFetchRefreshDataSource(albumName: albumName, collectionType: .smartAlbum, collectionSubType: .smartAlbumSlomoVideos)
    }
    
    
    
    func albumVCViewWillDisAppear() {
        //
    }
    
    
    fileprivate func handleFetchRefreshDataSource(albumName: String, collectionType: PHAssetCollectionType, collectionSubType: PHAssetCollectionSubtype) {
        handleAlbumContainerViewVisibility()
        delegate?.isLoadingNewAlbumIntoDataSource()

        PHLibraryAPI.shared.fetchSpecificSmartAlbum(collectionType: collectionType, collectionSubType: collectionSubType, fetchOptions: assetFetchOptions()) {[weak self] (assets) in
            guard let self = self else {return}
            self.videosCellDataSource.removeAll()
            self.imagesCellDataSource.removeAll()
            self.navLabelTitle = albumName

           
            self.handleFilterMediaTypeOutOf(mediaType: .video, album: assets) {[weak self] (filteredAlbum) in
                self?.videosCellDataSource = filteredAlbum ?? []
                self?.delegate?.didChangeAlbum(album: filteredAlbum ?? [])

//                self?.delegate?.didChangeVideosAlbum(album: assets)
                self?.collectionView.reloadData()
            }
           
            self.handleFilterMediaTypeOutOf(mediaType: .image, album: assets) {[weak self] (filteredAlbum) in
               self?.imagesCellDataSource = filteredAlbum ?? []
                self?.delegate?.didChangeAlbum(album: filteredAlbum ?? [])

//                self?.delegate?.didChangePhotosAlbum(album: assets)
               self?.collectionView.reloadData()
           }
        }
        
    }
    
    
    fileprivate func handleFilterMediaTypeOutOf(mediaType: PHAssetMediaType, album: [PHAsset], completion: @escaping ([PHAsset]?) -> ()) {
        var filteredAlbum = [PHAsset]()
        for (index, phasset) in album.enumerated() {
            if phasset.mediaType == mediaType {
                filteredAlbum.append(phasset)
            }
            
            if index == album.count - 1 {
                completion(filteredAlbum)
            }
        }
    }
    
}


//MARK: - MediaPickerBaseCellDelegate
extension MediaPickerVC: MediaPickerBaseCellDelegate {
    func didDeSelectMedia(asset: PHAsset) {
        didSelectMediaDelegate = bottomContainerView
        didSelectMediaDelegate?.didDeSelectMedia(asset: asset)

    }
    
    func didSelectMedia(asset: PHAsset) {
        didSelectMediaDelegate = bottomContainerView
        didSelectMediaDelegate?.didSelectMedia(asset: asset)
    }
    
}


//MARK: - SelectedAssetsViewDelegate
extension MediaPickerVC: SelectedAssetsViewDelegate {
    
    func didTapPreviewSelectedAssets(selectedAsset: PHAsset, allAssets: [PHAsset], currentIndexPath: IndexPath) {
        let dataSource = currentIndex == 0 ? videosCellDataSource : imagesCellDataSource
        
        if let indexToZoomTo = dataSource.firstIndex(of: selectedAsset) {
            let baseCellIndexPath = IndexPath(item: currentIndex, section: 0)
            guard let baseCell = collectionView.cellForItem(at: baseCellIndexPath) as? MediaPickerBaseCell else {return}
            let zoomInIndexPath = IndexPath(item: indexToZoomTo, section: 0)
            guard let startingCell = baseCell.collectionView.cellForItem(at: zoomInIndexPath) as? MediaPickerCell else {return}
            let size = CGSize(width: view.frame.width, height: view.frame.width)
            startingCell.imageView.image = getAssetThumbnail(asset: selectedAsset, size: size)
            handleDidTapZoomCellImageView(startingImageView: startingCell.imageView, cell: startingCell, currentIndexPath: currentIndexPath, selectedAssets: allAssets)
        }
    }
   
    
    func didTapRemoveSelected(asset: PHAsset) {
        delegate?.didTapRemoveSelected(asset: asset)
        didSelectMediaDelegate?.didDeSelectMedia(asset: asset)
    }
    
    
    
    @objc func handleDidTapZoomCellImageView(startingImageView: UIImageView, cell: MediaPickerCell, currentIndexPath: IndexPath, selectedAssets: [PHAsset]) {
              if let startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil) {
               self.startingFrame = startingFrame
               let zooomingImageView = UIImageView(frame: startingFrame)
               self.zooomingImageView = zooomingImageView
               zooomingImageView.image = startingImageView.image
               zooomingImageView.isUserInteractionEnabled = true
               
               if let keyWindow = UIApplication.shared.keyWindow {
                   let previewSelectedAssetsView = PreviewSelectedAssetsView(currentIndexPath: currentIndexPath, selectedAssets: selectedAssets)
                   previewSelectedAssetsView.delegate = self
                   previewSelectedAssetsView.frame = keyWindow.frame
                   previewSelectedAssetsView.backgroundColor = .black
                   self.previewSelectedAssetsView = previewSelectedAssetsView
                   
                   
                   
                   keyWindow.addSubview(previewSelectedAssetsView)
                   keyWindow.addSubview(zooomingImageView)
              
                   
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: { [weak self] in
                                  
                          guard let self = self else {return}
                          
//                          self.multipleSelectionContainer.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2)

                          self.zooomingImageView?.contentMode = .scaleAspectFit
                          
                          var height = keyWindow.frame.height

                          if UIDevice.current.hasNotch {
                              
                              height = keyWindow.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom

                              //... consider notch for iphone X and its notch bros
                          } else {
                              
                              //... don't have to consider notch
                          }
                          

                          zooomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                          zooomingImageView.center = keyWindow.center

                          
                      }) { (completed) in
                          //do nothing
                       keyWindow.bringSubviewToFront(previewSelectedAssetsView)
                      }
           

               }


                  
              }

          }

}



//MARK: - PreviewSelectedAssetsViewDelegate
extension MediaPickerVC: PreviewSelectedAssetsViewDelegate {
    func handleZoomBackToIdentity(zoomBackToThisAsset: PHAsset) {
        let theRightBaseIndex = zoomBackToThisAsset.mediaType == .video ? 0 : 1

        handleScrollBaseCollectionViewTo(menuIndex: theRightBaseIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let dataSource = self.currentIndex == 0 ? self.videosCellDataSource : self.imagesCellDataSource
            self.handleRefactorZoomCode(zoomBackToThisAsset: zoomBackToThisAsset, dataSource: dataSource)
        }

        
    }
    
    
    
    fileprivate func handleRefactorZoomCode(zoomBackToThisAsset: PHAsset, dataSource: [PHAsset]) {
             
             
             
             guard let indexToZoomTo = dataSource.firstIndex(of: zoomBackToThisAsset) else {
                handleZoomBackToIdentity(zoomBackToThisAsset: zoomBackToThisAsset)
                return}
             
             
             let baseCellIndexPath = IndexPath(item: currentIndex, section: 0)
             
             
             guard let baseCell = collectionView.cellForItem(at: baseCellIndexPath) as? MediaPickerBaseCell else {
                handleZoomBackToIdentity(zoomBackToThisAsset: zoomBackToThisAsset)

                return}
             
             
                let zoomInIndexPath = IndexPath(item: indexToZoomTo, section: 0)
             
             baseCell.collectionView.scrollToItem(at: zoomInIndexPath, at: .centeredVertically, animated: false)

             
                guard let cell = baseCell.collectionView.cellForItem(at: zoomInIndexPath) as? MediaPickerCell else {
                    handleZoomBackToIdentity(zoomBackToThisAsset: zoomBackToThisAsset)

                    return}

              guard let frameToZoomBackTo = cell.imageView.superview?.convert(cell.imageView.frame, to: nil)  else {
                handleZoomBackToIdentity(zoomBackToThisAsset: zoomBackToThisAsset)

                return}

        
            if let zoomOutImageView = zooomingImageView {
                zoomOutImageView.image = cell.imageView.image
                zoomOutImageView.contentMode = .scaleAspectFill
                zoomOutImageView.clipsToBounds = true
                zoomOutImageView.layer.borderWidth = 0.5
                zoomOutImageView.layer.borderColor = UIColor.init(white: 0.5, alpha: 0.5).cgColor

                UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                    guard let self = self else {return}

                        zoomOutImageView.frame = frameToZoomBackTo
                        
                        [self.previewSelectedAssetsView].forEach({ (subView) in
                            subView?.alpha = 0
                        })

                    
                }) { [weak self] (completed) in
                    
                    guard let self = self else {return}

                    zoomOutImageView.removeFromSuperview()
                    self.previewSelectedAssetsView?.removeFromSuperview()
                    self.startingImageView?.isHidden = false
                    
                }
            }
    }
    
   
}



extension UIDevice {
    
    /// Returns 'true' if the current device has a notch
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            // Case 1: Portrait && top safe area inset >= 44
            let case1 = !UIDevice.current.orientation.isLandscape && (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) >= 44
            // Case 2: Lanscape && left/right safe area inset > 0
            let case2 = UIDevice.current.orientation.isLandscape && ((UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0) > 0 || (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0) > 0)
            
            return case1 || case2
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}
