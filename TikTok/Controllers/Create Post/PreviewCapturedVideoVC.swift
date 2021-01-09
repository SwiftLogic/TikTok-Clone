//
//  PreviewCaptureVideoVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
class PreviewCapturedVideoVC: UIViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        thumbbnailImageView.image = thumbnailImage
        handleMirrorPlayer()
        perform(#selector(setUpPlayerView), with: 0, afterDelay: 0.5)
        hideStatusBar = true
        //hides back btn
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.backBarButtonItem = backButton

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        player.play()
        hideStatusBar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    init(videoURLFromTempDirectory: URL, thumbnailImage: UIImage, cameraPosition: AVCaptureDevice.Position) {
        self.videoURLFromTempDirectory = videoURLFromTempDirectory
        self.thumbnailImage = thumbnailImage
        self.cameraPosition = cameraPosition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    
   fileprivate var cameraPosition: AVCaptureDevice.Position
    

    
    private var hideStatusBar: Bool = true {
        didSet {
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
            }
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    fileprivate let buttonsDimension: CGFloat = 28 
    fileprivate let buttonsRightPadding: CGFloat = 17

    fileprivate let videoURLFromTempDirectory: URL
    fileprivate let thumbnailImage: UIImage
    
    let cancelButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
       button.tintColor = .white
       button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
       return button
   }()
    
    
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(addFiltersToClipIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    
    let adjustClipsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(adjustclipsicon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    
    let voiceEffectsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(voiceEffectsIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        
        return button
    }()
    
    
    
    let voiceOverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(microphoneIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    
    
   let filtersLabel: UILabel = {
       let label = UILabel()
       label.text = "Filters"
       label.font = defaultFont(size: 9.5)
       label.textColor = .white
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   let adjustClipsLabel: UILabel = {
       let label = UILabel()
       label.text = "Adjust clips"
       label.font = defaultFont(size: 9.5)
       label.textColor = .white
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    
    let voiceEffectsLabel: UILabel = {
       let label = UILabel()
       label.text = "Voice \nEffects"
        label.font = defaultFont(size: 9.5)
       label.textColor = .white
       label.numberOfLines = 0
        label.textAlignment = .center
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
   let voiceOverLabel: UILabel = {
        let label = UILabel()
        label.text = "Voiceover"
        label.font = defaultFont(size: 9.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()
   
       
    
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    
    fileprivate let thumbbnailImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       return imageView
   }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.backgroundColor = tikTokRed
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDidTapNext), for: .touchUpInside)
        return button
    }()
    
    lazy var soundEffectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(musicIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    
    lazy var timeEffectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(timeEffectsIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    
    lazy var stickersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(emojiIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    
    lazy var enterTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(enterTextIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    let soundEffectLabel: UILabel = {
        let label = UILabel()
        label.text = "Sounds"
        label.font = defaultFont(size: 9.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let timeEffectLabel: UILabel = {
        let label = UILabel()
        label.text = "Effects"
        label.font = defaultFont(size: 9.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let enterTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Texts"
        label.font = defaultFont(size: 9.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let addStickersLabel: UILabel = {
        let label = UILabel()
        label.text = "Stickers"
        label.font = defaultFont(size: 9.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
    view.addSubview(thumbbnailImageView)
    thumbbnailImageView.fillSuperview()
        
     view.addSubview(cancelButton)
     cancelButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 12, bottom: 0, right: 0), size: .init(width: buttonsDimension, height: buttonsDimension))
        
        
    view.addSubview(filterButton)
    filterButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: buttonsRightPadding), size: .init(width: buttonsDimension, height: buttonsDimension))
               
    view.addSubview(adjustClipsButton)
    adjustClipsButton.anchor(top: filterButton.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 38, left: 0, bottom: 0, right: buttonsRightPadding), size: .init(width: buttonsDimension, height: buttonsDimension))
          
        

      view.addSubview(voiceEffectsButton)
      voiceEffectsButton.anchor(top: adjustClipsButton.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 38, left: 0, bottom: 0, right: buttonsRightPadding), size: .init(width: buttonsDimension, height: buttonsDimension))
        
        
        
        view.addSubview(voiceOverButton)
        voiceOverButton.anchor(top: voiceEffectsButton.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 45, left: 0, bottom: 0, right: buttonsRightPadding), size: .init(width: buttonsDimension, height: buttonsDimension))
          
          

        view.addSubview(filtersLabel)
        filtersLabel.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 4).isActive = true
        filtersLabel.centerXAnchor.constraint(equalTo: filterButton.centerXAnchor).isActive = true

        
        view.addSubview(adjustClipsLabel)
        adjustClipsLabel.topAnchor.constraint(equalTo: adjustClipsButton.bottomAnchor, constant: 4).isActive = true
        adjustClipsLabel.centerXAnchor.constraint(equalTo: adjustClipsButton.centerXAnchor).isActive = true

        
       view.addSubview(voiceEffectsLabel)
       voiceEffectsLabel.topAnchor.constraint(equalTo: voiceEffectsButton.bottomAnchor, constant: 4).isActive = true
       voiceEffectsLabel.centerXAnchor.constraint(equalTo: voiceEffectsButton.centerXAnchor).isActive = true

        
        
        view.addSubview(voiceOverLabel)
        voiceOverLabel.topAnchor.constraint(equalTo: voiceOverButton.bottomAnchor, constant: 4).isActive = true
        voiceOverLabel.centerXAnchor.constraint(equalTo: voiceOverButton.centerXAnchor).isActive = true
        
        
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: filterButton.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 30, right: 0), size: .init(width: 70, height: 38))

        
          let stackView = UIStackView(arrangedSubviews: [soundEffectButton, timeEffectButton, enterTextButton, stickersButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nextButton.topAnchor, leading: cancelButton.leadingAnchor, bottom: nil, trailing: nextButton.leadingAnchor, padding: .init(top: -4, left: 0, bottom: 0, right: 33),size: .init(width: 0, height: 33)) //right: 40
//        stackView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true

        
        
        view.addSubview(soundEffectLabel)
        soundEffectLabel.topAnchor.constraint(equalTo: soundEffectButton.bottomAnchor, constant: 4.5).isActive = true
        soundEffectLabel.centerXAnchor.constraint(equalTo: soundEffectButton.centerXAnchor).isActive = true
               
        
        view.addSubview(timeEffectLabel)
        timeEffectLabel.topAnchor.constraint(equalTo: timeEffectButton.bottomAnchor, constant: 4.5).isActive = true
        timeEffectLabel.centerXAnchor.constraint(equalTo: timeEffectButton.centerXAnchor).isActive = true
           
        
        view.addSubview(enterTextLabel)
        enterTextLabel.topAnchor.constraint(equalTo: enterTextButton.bottomAnchor, constant: 4.5).isActive = true
        enterTextLabel.centerXAnchor.constraint(equalTo: enterTextButton.centerXAnchor).isActive = true
          
        
        view.addSubview(addStickersLabel)
        addStickersLabel.topAnchor.constraint(equalTo: stickersButton.bottomAnchor, constant: 4.5).isActive = true
        addStickersLabel.centerXAnchor.constraint(equalTo: stickersButton.centerXAnchor).isActive = true
              
        
    }
    
    
    @objc fileprivate func handleDidTapNext() {
        hideStatusBar = false
        let sharePostVC = SharePostVC()
        sharePostVC.thumbnailImageView.image = thumbbnailImageView.image
        navigationController?.pushViewController(sharePostVC, animated: true)
    }
    
    @objc fileprivate func setUpPlayerView() {
        //setup playerview
        let player = AVPlayer(url: videoURLFromTempDirectory)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = thumbbnailImageView.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.player = player
        self.playerLayer = playerLayer
        thumbbnailImageView.layer.insertSublayer(playerLayer, at: 3)
        player.play()
        //alerts that video completed playing
        NotificationCenter.default.addObserver(self, selector: #selector(aVPlayerItemDidPlayToEndTime(notification:)),
                                                      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    
    @objc func aVPlayerItemDidPlayToEndTime(notification: Notification) {
        player.seek(to: CMTime.zero)
        player.play()
        print("changePlayButtonImage")
    }
    
    
    @objc func handleNavigateBack() {
        hideStatusBar = true
        navigationController?.popViewController(animated: true)
    }
    
    
    
    fileprivate func handleMirrorPlayer() {
        if cameraPosition == .front {
            //MARK: - only MIRROW thumbbnailImageView that houses the avplayerlayer if the video was recorded with front cam
            thumbbnailImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}
