//
//  PreviewSelectedAssetsView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 12/3/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
import Photos
protocol PreviewSelectedAssetsViewDelegate: class {
    func handleZoomBackToIdentity(zoomBackToThisAsset: PHAsset)
}
class PreviewSelectedAssetsView: UIView {
    

    
    //MARK: - Init
    //this how to do a custom init
    required init(currentIndexPath: IndexPath, selectedAssets: [PHAsset]) {
        self.currentIndexPath = currentIndexPath
        self.selectedAssets = selectedAssets
        super.init(frame: CGRect.zero)
        setUpViews()
        perform(#selector(handleViewDidAppear), with: nil, afterDelay: 0.4)
        perform(#selector(handleSetUpFirstCellUponViewdidLoad), with: nil, afterDelay: 0.3)
    }
    
    
    deinit {
        print("PreviewSelectedPostView deinited")
    }
    
    
    
    
    //MARK: - Properties
    private let selectedAssets: [PHAsset]
    var isOpeningForFirstTime = true
    var currentIndexPath: IndexPath
    weak var delegate: PreviewSelectedAssetsViewDelegate?
    
    
    fileprivate let cellReuseId = "God is thhe ggreatest and his mercies and ggrace endureth forever"
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = 0
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(PreviewSelectedAssetCell.self, forCellWithReuseIdentifier: cellReuseId)
    }
    
    
    @objc fileprivate func handleViewDidAppear() {
        isOpeningForFirstTime = false
        collectionView.alpha = 1
    }
    
    
    //sets up first cell upon vie
      @objc fileprivate func handleSetUpFirstCellUponViewdidLoad() {
          let asset = selectedAssets[currentIndexPath.item]
        if asset.mediaType == .video {
              guard let cell = collectionView.cellForItem(at: currentIndexPath) as? PreviewSelectedAssetCell else {return}
            prepareToLoadVideoUrlIntoPlayer(asset, cell)
          }
      }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




 //MARK: - CollectionView Delegates

extension PreviewSelectedAssetsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! PreviewSelectedAssetCell
        cell.phAsset = selectedAssets[indexPath.item]
        let asset = selectedAssets[indexPath.item]
        let size = PHImageManagerMaximumSize
        cell.imageView.image = getAssetThumbnail(asset: asset, size: size)
        cell.phAsset = asset
        let videoLegthInString = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
        cell.videoDurationLabel.text = videoLegthInString
        cell.delegate = self
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          
           isOpeningForFirstTime == true ? collectionView.scrollToItem(at: currentIndexPath, at: [], animated: false) : nil
       }
       
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width, height: frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedAssets.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    fileprivate func prepareToLoadVideoUrlIntoPlayer(_ asset: PHAsset, _ cell: PreviewSelectedAssetCell) {
        if asset.mediaType == .video {
            asset.getURL { [weak self] (url, image, avasset) in
                DispatchQueue.main.async { [weak self] in
                    if let urlUnwrapped = url  {
                        self?.handleSetUpPlayer(url: urlUnwrapped, cell: cell)
                    }
                }
            }
        } else if asset.mediaType == .image {
            removePeriodicTimeObserver()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / frame.width)
        let indexPath = IndexPath(item: pageNumber, section: 0)
        currentIndexPath = indexPath
        
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PreviewSelectedAssetCell else {return}
        collectionView.isScrollEnabled = false //prevents user from scrolling too fast. the point is to slow down scroll speed
        perform(#selector(handleSwitchCollectionViewInteraction), with: nil, afterDelay: 0.5)
        
        let asset = selectedAssets[indexPath.item]
        prepareToLoadVideoUrlIntoPlayer(asset, cell)
    }
    
    
    @objc func handleSwitchCollectionViewInteraction() {
        //reallows user to scroll
        collectionView.isScrollEnabled =  true
    }
}


extension PreviewSelectedAssetsView: PreviewSelectedAssetCellDelegate {
    func didTapCancelButton(asset: PHAsset) {
        removePeriodicTimeObserver()
        delegate?.handleZoomBackToIdentity(zoomBackToThisAsset: asset)
    }
}


//MARK: - AVKit Functionality
extension PreviewSelectedAssetsView {
    
      fileprivate func handleSetUpPlayer(url: URL, cell: PreviewSelectedAssetCell) {
            removePeriodicTimeObserver()
            //to cancel out currently playing player
            player.replaceCurrentItem(with: nil) //this right here removes all previes players before initializing
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = cell.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            self.player = player
            self.playerLayer = playerLayer
            cell.playerView.layer.insertSublayer(playerLayer, at: 0)
            player.play()
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEndTime),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
        
        
   fileprivate func removePeriodicTimeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        player.replaceCurrentItem(with: nil)
    }
    
    
    
    @objc fileprivate func playerDidPlayToEndTime(notification: Notification) {
        player.seek(to: .zero)
        player.play()
    }
    
        
    
}
