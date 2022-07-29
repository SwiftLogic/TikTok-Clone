//
//  TrimVideoVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 4/9/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
import Photos
import PryntTrimmerView
class TrimVideoVC: UIViewController {
    
    
    //MARK: - Init
    init(videoURL: URL, asset: AVAsset) {
        self.videoURL = videoURL
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("TrimVideoVC deinitialized:")
        removePeriodicTimeObserver()
    }
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSetUpViews()
        setUpPlayerView(with: videoURL)
        handleSetUpTapGesture()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handlePausePlay(play: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handlePausePlay(play: false)
    }
    
    
    //MARK: - Properties
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate var currentOrientation: CGFloat = 0
    fileprivate let videoURL : URL
    fileprivate let asset : AVAsset
    fileprivate var isPlaying = false
    fileprivate var timeObserverToken: Any?
    
    fileprivate let videoCanvas: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate var currentPlayRate: Float = 1
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
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
    
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let cancelImage = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)!
        button.setImage(cancelImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return button
    }()
    
    
    let timerButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        let cancelImage = UIImage(systemName: "timer", withConfiguration: symbolConfig)!
        button.setImage(cancelImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDidTapTimerButton), for: .touchUpInside)
        return button
    }()
    
    let rotateButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        let cancelImage = UIImage(systemName: "rotate.right", withConfiguration: symbolConfig)!
        button.setImage(cancelImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleRotate), for: .touchUpInside)
        return button
    }()

    
    fileprivate lazy var trimmerView: TrimmerView = {
        let trimmerView = TrimmerView()
        trimmerView.mainColor = tikTokRed
        trimmerView.handleColor = .white
        trimmerView.delegate = self
        trimmerView.maxDuration = .infinity
        return trimmerView
    }()
   
    
    fileprivate let selectedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = defaultFont(size: 13)
//        label.text = "22.9s selected"
        return label
    }()
    
    fileprivate let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 55, weight: .bold, scale: .large)
        let cancelImage = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)!
        button.setImage(cancelImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    
    lazy var videoSpeedView: VideoSpeedView = {
        let videoSpeedView = VideoSpeedView()
        videoSpeedView.delegate = self
        videoSpeedView.alpha = 0
        return videoSpeedView
    }()
    

    
    //MARK: - Handlers
    fileprivate func handleSetUpViews() {
        view.addSubview(videoCanvas)
        videoCanvas.fillSuperview()
        
        view.addSubview(nextButton)
        nextButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 30, right: 12), size: .init(width: 70, height: 33))
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 45, height: 45))
        cancelButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        
        view.addSubview(trimmerView)
        trimmerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 35, bottom: 30, right: 35), size: .init(width: 0, height: 55))
        
        trimmerView.asset = asset
        trimmerView.asset = asset
        
        
        view.addSubview(selectedTimeLabel)
        selectedTimeLabel.anchor(top: nil, leading: trimmerView.leadingAnchor, bottom: trimmerView.topAnchor, trailing: nil, padding: .init(top: 0, left: -20, bottom: 16, right: 0))
        
        
        view.addSubview(rotateButton)
        rotateButton.anchor(top: nil, leading: nil, bottom: trimmerView.topAnchor, trailing: trimmerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 0))
       
        view.addSubview(timerButton)
        timerButton.anchor(top: nil, leading: nil, bottom: trimmerView.topAnchor, trailing: rotateButton.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 10))
        
        
        view.addSubview(pausePlayButton)
        pausePlayButton.centerInSuperview()
        
        
        
        
        view.addSubview(videoSpeedView)
        videoSpeedView.anchor(top: nil, leading: trimmerView.leadingAnchor, bottom: selectedTimeLabel.topAnchor, trailing: trimmerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init(width: 0, height: VideoSpeedView.stackViewHeight))

    }
    
    
    
    fileprivate func setUpPlayerView(with videoUrl: URL) {
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = view.frame
        self.player = player
        self.playerLayer = playerLayer
        videoCanvas.layer.addSublayer(playerLayer)
        player.play()
        isPlaying = true
        NotificationCenter.default.addObserver(self, selector: #selector(aVPlayerItemDidPlayToEndTime(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        
        
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.001, preferredTimescale: timeScale) //fires every 0.001 seconds
        timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
            
            guard let self = self,
                  let startTime = self.trimmerView.startTime, let endTime = self.trimmerView.endTime else {return}
            let trimmedTime: Int = Int(CMTimeGetSeconds(endTime)  - CMTimeGetSeconds(startTime))
            
            guard let currentItemDuration = self.player.currentItem?.duration else {return}
            let totalDurationInSeconds = CMTimeGetSeconds(currentItemDuration)
            
            guard totalDurationInSeconds.isFinite else {return}
            
            
            let seconds =  CMTimeGetSeconds(progressTime) - CMTimeGetSeconds(startTime)
            let positiveOrZero = max(seconds, 0) //makes sure it doesnt go below 0 i.e no negative readings
            
            guard positiveOrZero.isFinite else {return}

            guard totalDurationInSeconds.isFinite else {return} //prevents crashes
            
            //moves trimmer view position bar to current cmtime
            let playerCurrentCMTime = player.currentTime()
            self.trimmerView.seek(to: playerCurrentCMTime)
            
            self.selectedTimeLabel.text =  String(format: "%02d:%02d",Int((trimmedTime / 60)),Int(trimmedTime) % 60) + "s" + " " + "selected"
            
        })
    }
    
    
    func removePeriodicTimeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
            player.replaceCurrentItem(with: nil)
            
        }
    }
    
    private func handleSetUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    fileprivate func handlePausePlay(play: Bool) {
        if play == true {
            pausePlayButton.alpha = 0
            player.play()
            player.rate = currentPlayRate
            isPlaying = true
        } else {
            pausePlayButton.alpha = 1
            player.pause()
            isPlaying = false
        }
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func handleDidTapNext() {
        let videoClip = VideoClips(videoUrl: videoURL, cameraPosition: .back)
        let previewCaptureVC = PreviewCapturedVideoVC(recordedClips: [videoClip])
        navigationController?.pushViewController(previewCaptureVC, animated: true)
    }
    
    
    
    
    @objc fileprivate func handleRotate() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            if self.currentOrientation == 0 {
                self.videoCanvas.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                self.currentOrientation = CGFloat.pi / 2
                
            } else if self.currentOrientation == CGFloat.pi / 2 {
                self.videoCanvas.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.currentOrientation = CGFloat.pi
                
            } else if self.currentOrientation == CGFloat.pi {
                self.videoCanvas.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.5)
                self.currentOrientation = CGFloat.pi * 1.5
            } else if self.currentOrientation == CGFloat.pi * 1.5 {
                self.videoCanvas.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
                self.currentOrientation = 0
            }
        }
    }
    
    
    @objc fileprivate func handleDidTapTimerButton() {
        if videoSpeedView.alpha == 0 {
            videoSpeedView.alpha = 1
        } else {
            videoSpeedView.alpha = 0
        }
    }
    
    
    
    @objc func aVPlayerItemDidPlayToEndTime(notification: Notification) {
        let newCMStartTime = trimmerView.startTime ?? CMTime.zero
        player.seek(to: newCMStartTime)
        player.play()
        player.rate = currentPlayRate
    }

    
    @objc fileprivate func handleGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc fileprivate func handleTapGesture() {
        if isPlaying == false {
            handlePausePlay(play: true)
        } else {
            handlePausePlay(play: false)
        }
        handleAnimatePlayButton()
    }
    
    
    fileprivate func handleAnimatePlayButton() {
        pausePlayButton.transform = .init(scaleX: 3, y: 3)
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.pausePlayButton.transform = .identity
        }
    }
}

//MARK: - TrimmerViewDelegate
extension TrimVideoVC: TrimmerViewDelegate {
    func didChangePositionBar(_ playerTime: CMTime) {
        guard let startCmTime = trimmerView.startTime, let endCmTime = trimmerView.endTime else {return}
        player.seek(to: startCmTime)
        handlePausePlay(play: true)
        //     //sets player's newend cmtime to trimmerview endtime
        player.currentItem?.forwardPlaybackEndTime = endCmTime
        guard let startTime = self.trimmerView.startTime, let endTime = self.trimmerView.endTime else {return}
        let trimmedTime: Int = Int(CMTimeGetSeconds(endTime)  - CMTimeGetSeconds(startTime))
        selectedTimeLabel.text =  String(format: "%02d:%02d",Int((trimmedTime / 60)),Int(trimmedTime) % 60) + "s" + " " + "selected"
    
    }
    
    func positionBarStoppedMoving(_ playerTime: CMTime) {}
    
    
}

//MARK: - VideoSpeedViewDelegate
extension TrimVideoVC: VideoSpeedViewDelegate {
    func didChangeVideoPlayRate(with rate: Float) {
        currentPlayRate = rate
        handlePausePlay(play: true)
    }
}
