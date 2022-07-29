//
//  SyncVideosVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 4/14/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
class SyncVideosVC: UIViewController {
    
    
    //MARK: - Init
    init(selectedVideoMedia: [SelectedVideoMedia]) {
        self.selectedVideoMedia = selectedVideoMedia
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 18, green: 18, blue: 18)
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpPlayerView(with: selectedVideoMedia.first!)
    }
    
    
    
    
    //MARK: - Properties
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let selectedVideoMedia: [SelectedVideoMedia]
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let cancelImage = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)!
        button.setImage(cancelImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return button
    }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.backgroundColor = tikTokRed
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(handleDidTapNext), for: .touchUpInside)
        return button
    }()
    
    
    
    fileprivate let videoCanvas: UIView = {
        let view = UIView()
        view.backgroundColor = .black
//        let scaleScrollView = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//        let translateScrollView = CGAffineTransform(translationX: 0, y: -75) //-100 //translates up
//        view.transform = (scaleScrollView).concatenating(translateScrollView); //concats (adds) multiple CoreGraphics transformations on a view
        return view
    }()
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    
    
    fileprivate let syncSoundbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sound Sync    ", for: .normal)
        button.titleLabel?.font = appleNeoBold(size: 15)//UIFont.systemFont(ofSize: 13.5, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    fileprivate let defaultSoundbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Default", for: .normal)
        button.titleLabel?.font = appleNeoBold(size: 15)//UIFont.systemFont(ofSize: 13.5, weight: .semibold)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    
    
    
    fileprivate let verticalLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    fileprivate lazy var suggestedSoundsView: SuggestedSoundsView = {
        let view = SuggestedSoundsView()
        view.delegate = self
        return view
    }()
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {

        view.addSubview(nextButton)
        nextButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 30, right: 12), size: .init(width: 70, height: 33))
      
        view.addSubview(cancelButton)
        cancelButton.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 45, height: 45))
        cancelButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        
        
        let padding: CGFloat = 70 //derived from nextbutton width
        view.addSubview(videoCanvas)
//        videoCanvas.fillSuperview()
        videoCanvas.anchor(top: nextButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: view.frame.width - 25))//+ 25))
        
        
        let stackView = UIStackView(arrangedSubviews: [syncSoundbutton, defaultSoundbutton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        stackView.anchor(top: videoCanvas.bottomAnchor, leading: videoCanvas.leadingAnchor, bottom: nil, trailing: videoCanvas.trailingAnchor, size: .init(width: 0, height: 50))

        stackView.addSubview(verticalLineSeperator)
        verticalLineSeperator.centerInSuperview(size: .init(width: 0.5, height: 8.5))
        
        view.addSubview(suggestedSoundsView)
//        suggestedSoundsContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height / 3))

        suggestedSoundsView.anchor(top: syncSoundbutton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
       
    }
    
    
    @objc fileprivate func handleGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func setUpPlayerView(with videoClip: SelectedVideoMedia) {
       //setup playerview
       let player = AVPlayer(url: videoClip.videoUrl)
       let playerLayer = AVPlayerLayer(player: player)
       self.player = player
       self.playerLayer = playerLayer
       playerLayer.frame = videoCanvas.bounds
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
       self.player = player
       self.playerLayer = playerLayer
       videoCanvas.layer.addSublayer(playerLayer)
       player.play()
       //alerts that video completed playing
//       NotificationCenter.default.addObserver(self, selector: #selector(aVPlayerItemDidPlayToEndTime(notification:)),
//                                                     name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//       handleMirrorPlayer(cameraPosition: videoClip.cameraPosition)
   }
   
    
}



//MARK: - SuggestedSoundsViewDelegate
extension SyncVideosVC: SuggestedSoundsViewDelegate {
    func didTapAdjustClips() {
        //put a maintainance comment for the gazibo
    }
    
    func didTapSearchForMoreSounds() {
        let soundsVC = SoundsVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = MyNavigationController(rootViewController: soundsVC)
//        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
