//
//  PreviewCaptureVideoVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
import SwiftVideoGenerator
import EasyTipView
import SVProgressHUD
class PreviewCapturedVideoVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Init
    deinit {
        SVProgressHUD.show(withStatus: "PreviewCapturedVideoVC was deinited")
        SVProgressHUD.dismiss(withDelay: 2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
//        thumbbnailImageView.image = thumbnailImage
        handleStartPlayingFirstClip()
//        perform(#selector(setUpPlayerView), with: 0, afterDelay: 0.5)
        hideStatusBar = true
        //hides back btn
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.backBarButtonItem = backButton
//        handleMergeClips(clips: recordedClips)
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
        dismissEasyTipView()
    }
    
    init(recordedClips: [VideoClips]) {
        self.currentlyPlayingVideoClip = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    fileprivate lazy var defaultStickerWidthHeight = CGFloat(view.frame.width)
    fileprivate let recordedClips: [VideoClips]
    fileprivate var activeSticker: Sticker?
    fileprivate var allStickers: [Sticker] = []
    

    
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

    fileprivate var currentlyPlayingVideoClip: VideoClips
//    fileprivate let thumbnailImage: UIImage
    
    
    var easyTipView: EasyTipView?
    
    let mainCanvasView: UIView = {
        let view = UIView()
        return view
    }()

      lazy var setDurationButton: UIButton = {
          let setDurationButton = UIButton(type: .system)
          let image = UIImage(named: "clock-circular-outline")
          setDurationButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
          setDurationButton.setTitle("  Set duration", for: .normal)
          setDurationButton.titleLabel?.font = defaultFont(size: 15)
        handleSetUpButtonImageView(button: setDurationButton, buttonWidth: 16, topInset: 1.5, paddingLeft: 16.5)
          setDurationButton.addTarget(self, action: #selector(didTapSetStickerButton), for: .allTouchEvents)
          return setDurationButton

      }()
          
          
      lazy var editButton: UIButton = {
       let editButton = UIButton(type: .system)
       let editImage = UIImage(named: "edit (2)")//"clock-circular-outline")
       editButton.setImage(editImage?.withRenderingMode(.alwaysTemplate), for: .normal)
       editButton.setTitle("  Edit text", for: .normal)
       editButton.titleLabel?.font = defaultFont(size: 15)
       editButton.addTarget(self, action: #selector(didTapEditStickerButton), for: .allTouchEvents)
       handleSetUpButtonImageView(button: editButton, buttonWidth: 16, topInset: 3.8, paddingLeft: 16.5)
       return editButton
          
      }()
    
    
    lazy var deleteButton: UIButton = {
       let deleteButton = UIButton(type: .system)
       let deleteImage = UIImage(named: "trash")//"clock-circular-outline")
       deleteButton.setImage(deleteImage?.withRenderingMode(.alwaysTemplate), for: .normal)
       deleteButton.setTitle("  Delete text", for: .normal)
       deleteButton.titleLabel?.font = defaultFont(size: 15)
       deleteButton.addTarget(self, action: #selector(didTapDeleteStickerButton), for: .allTouchEvents)
       handleSetUpButtonImageView(button: deleteButton, buttonWidth: 16, topInset: 3.8, paddingLeft: 16.5)
       return deleteButton
              
    }()
       
       fileprivate let horizontalLineSeperatorView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
           return view
       }()
    
    
    fileprivate let deleteBtnHorizontalLineSeperatorView: UIView = {
          let view = UIView()
          view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
          return view
      }()
       
    
    
    
    
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
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    
    let adjustClipsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(adjustclipsicon?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    
    let voiceEffectsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(voiceEffectsIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        
        return button
    }()
    
    
    
    let voiceOverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(microphoneIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
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
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    
    lazy var timeEffectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(timeEffectsIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    
    lazy var stickersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(emojiIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(handleNavigateBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        return button
    }()
    
    
    
    lazy var enterTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(enterTextIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .white
        button.constrainWidth(constant: 23)
        button.constrainHeight(constant: 23)
        button.addTarget(self, action: #selector(handleDidTapEnterText), for: .touchUpInside)
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
    
    fileprivate lazy var setDurationContainerViewHeight: CGFloat = view.frame.height / 3.3
    
    fileprivate lazy var setDurationContainerView: SetDurationContainerView = {
        let view = SetDurationContainerView(videoUrl: recordedClips.first!.videoUrl)
        view.transform = CGAffineTransform(translationX: 0, y: setDurationContainerViewHeight)
        view.didTapDismissView = {[weak self] in
            self?.handleOpenOrCloseDurationsContainerView(open: false)
        }
        return view
    }()
    
    // MARK: - Gesture Recognizers
    fileprivate lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnStory(_:)))
        panGesture.delegate = self
        panGesture.maximumNumberOfTouches = 1
        return panGesture
    }()
    
    
    
    fileprivate lazy var pinchGesture: UIPinchGestureRecognizer = {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOnStory(_:)))
        pinchGesture.delegate = self
        return pinchGesture
    }()
    
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnStory(_:)))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    
    
    
    //MARK: - Gesture Handlers
        
        
        @objc fileprivate func didPanOnStory(_ sender: Any) {
            dismissEasyTipView()
            let recognizer = sender as! UIPanGestureRecognizer
            if recognizer.state == .began {
                self.activeSticker = self.findSticker(point: recognizer.location(in: view))
                if let sticker = self.activeSticker {
                    view.bringSubviewToFront(sticker)
                }else {
//                    let translation = recognizer.translation(in: view)
                }
                
            }else if recognizer.state == .changed {
                let translation = recognizer.translation(in: view)
                
                if let sticker = self.activeSticker {
                    
                    sticker.translation = translation

                }else{
                    
                    
                }
            }else if recognizer.state == .ended {
                if let sticker = self.activeSticker {
                    sticker.saveTranslation()
                    
//                    let gestureCenterPoint = recognizer.location(in: view)
                    //delete
                   
                    
                    
                } else {
                   
                }
                
            }
        }
        
        
        // For scaling (resizing) stickers
        @objc fileprivate func didPinchOnStory(_ sender: Any) {
            dismissEasyTipView()
            let recognizer = sender as! UIPinchGestureRecognizer
            self.activeSticker = self.findSticker(point: recognizer.location(in: view))
            if recognizer.state == .began {
                   self.activeSticker = self.findSticker(point: recognizer.location(in: view))
                   if let sticker = self.activeSticker {
                    view.bringSubviewToFront(sticker)
                   }
               }else if recognizer.state == .changed {
                   if let sticker = self.activeSticker {
                       sticker.scale = recognizer.scale
                   }
               }else if recognizer.state == .ended {
                   if let sticker = self.activeSticker {
                       sticker.saveScale()
                   }
               }
        }
        
        
       
        
        @objc fileprivate func didTapOnStory(_ sender: Any) {
            let recognizer = sender as! UITapGestureRecognizer
            self.activeSticker = self.findSticker(point: recognizer.location(in: view))
            if let sticker = self.activeSticker {
                
                view.bringSubviewToFront(sticker)
                showStickerOptionsButtons(text: "  Edit|Change \n\n\n", sticker: sticker, backgroundColor: UIColor.black.withAlphaComponent(0.9), font: UIFont.boldSystemFont(ofSize: 20), textColor: .white)

                
                
            } else {
                
            }
        }
        
        
        private func findSticker(point: CGPoint) -> Sticker? {
            var aSticker: Sticker? = nil
            self.allStickers.forEach { (sticker) in
                if sticker.frame.contains(point) {
                    aSticker = sticker
                }
            }
            return aSticker
        }
        
    
    
    // MARK: - Gesture Recognizer Delegate
       func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
       
       
        
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapSetStickerButton() {
         handleOpenOrCloseDurationsContainerView(open: true)
    }
    
    @objc fileprivate func didTapEditStickerButton() {
        guard let sticker = activeSticker, let stickerText = sticker.text, let stickerBackgroundColor = sticker.containerBackGroundColor, let stickerTextColor = sticker.stickerTextColor  else {return}
        dismissEasyTipView()
        sticker.removeFromSuperview()
        if let index = allStickers.firstIndex(of: sticker) {
            allStickers.remove(at: index)
        }
        
        let enterTextVC = EnterTextVC(stickerText: stickerText, stickerFont: sticker.stickerFont, stickerBackgroundColor: stickerBackgroundColor, textAlignment: sticker.stickerTextAlignment, stickerTextColor: stickerTextColor, currentTextViewBackgroundColoringStyle: sticker.currentTextViewBackgroundColoringStyle)
        enterTextVC.modalPresentationStyle = .overCurrentContext
        handleHideOrShowAllButtons(alpha: 0)
        enterTextVC.delegate = self
        present(enterTextVC, animated: true, completion: nil)
    }

    
    @objc fileprivate func didTapDeleteStickerButton() {
        guard let sticker = activeSticker else {return}
        dismissEasyTipView()
        sticker.removeFromSuperview()
        if let index = allStickers.firstIndex(of: sticker) {
            allStickers.remove(at: index)
        }
    }
    
    
   
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.addSubview(mainCanvasView)
        mainCanvasView.fillSuperview()
        mainCanvasView.addSubview(thumbbnailImageView)
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
        
        
        view.addSubview(setDurationContainerView)
        setDurationContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: setDurationContainerViewHeight))
              
        
        [panGesture, pinchGesture, tapGesture].forEach {(gesture) in view.addGestureRecognizer(gesture)}

    }
    
    
    
    
    
    @objc fileprivate func handleOpenOrCloseDurationsContainerView(open: Bool) {
        dismissEasyTipView()
        if open == true {
            handleAllButtonVisibility(alpha: 0) 
        }
            
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
            guard let self = self else {return}
            if open {
                let scaleTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                let translateTransform = CGAffineTransform(translationX: 0, y: -100) //translates up
                self.mainCanvasView.transform = (scaleTransform).concatenating(translateTransform); //concats (adds) multiple
                self.setDurationContainerView.transform = .identity
                
            } else {
                
                self.mainCanvasView.transform = .identity
                self.setDurationContainerView.transform = CGAffineTransform(translationX: 0, y: self.setDurationContainerViewHeight)
                self.handleAllButtonVisibility(alpha: 1)

            }
        })
    }
    
    @objc fileprivate func handleStartPlayingFirstClip() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let firstClip = self.recordedClips.first else {return}
            self.currentlyPlayingVideoClip = firstClip
            self.setUpPlayerView(with: firstClip)
        }
    }
    
    @objc fileprivate func handleDidTapNext() {
        hideStatusBar = false
        let sharePostVC = SharePostVC(videoUrl: currentlyPlayingVideoClip.videoUrl)
        sharePostVC.thumbnailImageView.image = thumbbnailImageView.image
        navigationController?.pushViewController(sharePostVC, animated: true)
    }
    
    
    @objc fileprivate func handleDidTapEnterText() {
        let enterTextVC = EnterTextVC()
        enterTextVC.modalPresentationStyle = .overCurrentContext
        handleHideOrShowAllButtons(alpha: 0)
        enterTextVC.delegate = self
        present(enterTextVC, animated: true, completion: nil)
    }
    
    
    fileprivate func handleHideOrShowAllButtons(alpha: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {[weak self] in
            self?.handleAllButtonVisibility(alpha: alpha)
        })
    }
    
    
    fileprivate func handleAllButtonVisibility(alpha: CGFloat) {
        [filterButton, filtersLabel, adjustClipsButton, adjustClipsLabel, voiceOverButton, voiceOverLabel, voiceEffectsButton, voiceEffectsLabel, soundEffectButton, soundEffectLabel, timeEffectButton, timeEffectLabel, enterTextButton, enterTextLabel, stickersButton, addStickersLabel, cancelButton, nextButton].forEach { (subView) in
            subView.alpha = alpha
        }
    }
    
    
     fileprivate func setUpPlayerView(with videoClip: VideoClips) {
        //setup playerview
        let player = AVPlayer(url: videoClip.videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = thumbbnailImageView.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.player = player
        self.playerLayer = playerLayer
        thumbbnailImageView.layer.insertSublayer(playerLayer, at: 3)
        player.play()
        //alerts that video completed playing
        NotificationCenter.default.addObserver(self, selector: #selector(aVPlayerItemDidPlayToEndTime(notification:)),
                                                      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        handleMirrorPlayer(cameraPosition: videoClip.cameraPosition)
    }
    
    
    func removePeriodicTimeObserver() {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
         player.replaceCurrentItem(with: nil)
         playerLayer.removeFromSuperlayer()
    }
    
    
    
   
    
    
    @objc func aVPlayerItemDidPlayToEndTime(notification: Notification) {
//        player.seek(to: CMTime.zero)
//        player.play()
        
        //get next clip to play, remove current avplayer from superview, init new video and repeat process in a loop
        //get next clip
        if let currentIndex = recordedClips.firstIndex(of: currentlyPlayingVideoClip) {
            let nextIndex = currentIndex + 1
            if  nextIndex > recordedClips.count - 1 {
                // last clip, restart loop
//                print("index this is the LAST clip we are restarting LOOOOP")
                removePeriodicTimeObserver()
                guard let firstClip = recordedClips.first else {return}
                setUpPlayerView(with: firstClip)
                currentlyPlayingVideoClip = firstClip

            } else {
                //keep looping
                for (index, clip) in recordedClips.enumerated() {
                    if index == nextIndex {
                        removePeriodicTimeObserver()
                        setUpPlayerView(with: clip)
                        currentlyPlayingVideoClip = clip
//                        print("index with url: \(clip)")
                    }
                }
            }
        }
    }
    
    
    @objc func handleNavigateBack() {
        hideStatusBar = true
        navigationController?.popViewController(animated: true)
    }
    
    
    
    fileprivate func handleMirrorPlayer(cameraPosition: AVCaptureDevice.Position) {
        if cameraPosition == .front {
            //MARK: - only MIRROW thumbbnailImageView that houses the avplayerlayer if the video was recorded with front cam
            thumbbnailImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            thumbbnailImageView.transform = .identity
        }
    }
    
    
    //MARK: - Merge recorded clips into one using AVFoundation //goal!
    @objc fileprivate func handleMergeClips(clips:[URL]){
        VideoGenerator.mergeMovies(videoURLs: clips) { (result) in
            switch result {
            case .success(let videoUrl):
                print("videoURL:", videoUrl)
//                self.currentlyPlayingVideoClip = videoUrl
//                self.perform(#selector(self.setUpPlayerView), with: 0, afterDelay: 0.5)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



//MARK: - EnterTextVCDelegate
extension PreviewCapturedVideoVC: EnterTextVCDelegate {
    
    
    func enterTextVCWillDisappear() {
        handleHideOrShowAllButtons(alpha: 1)
    }
    
    
     func addNewStickerToView(stickerText: String, textColor: UIColor, textAlignment: NSTextAlignment, stickerBackgroundColor: UIColor, stickerFont: UIFont, currentBackgroundColorStyle: TextViewBackgroundColoringStyle) {
             
                   
           let frame = CGRect(x: 0.0, y: 0.0, width: defaultStickerWidthHeight, height: defaultStickerWidthHeight)
           let sticker = Sticker(frame: frame)
           sticker.isUserInteractionEnabled = false
           sticker.text = stickerText
           sticker.stickerTextColor = textColor
           sticker.stickerTextAlignment = textAlignment
           sticker.stickerFont = stickerFont
           sticker.containerBackGroundColor = stickerBackgroundColor
           sticker.currentTextViewBackgroundColoringStyle = currentBackgroundColorStyle
    
           mainCanvasView.addSubview(sticker)
           sticker.translatesAutoresizingMaskIntoConstraints = false
           sticker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           sticker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

           
           //insert at zero so we can grab it and animate it
           allStickers.insert(sticker, at: 0)
           sticker.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//               perform(#selector(animateToLastLocation), with: nil, afterDelay: 0.3)
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateToLastLocation(sticker: sticker)
           }
            
        }
    
    
    
    @objc fileprivate func animateToLastLocation(sticker: Sticker) {
            guard let sticker = allStickers.first else {return}
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                sticker.transform = .identity
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
        
        
}


extension PreviewCapturedVideoVC {
    
    
    @objc func showStickerOptionsButtons(text: String, sticker: Sticker, backgroundColor: UIColor, font: UIFont, textColor: UIColor) {
             
              //dismiss eiting tip view
               dismissEasyTipView()
               var preferences = EasyTipView.Preferences()
               preferences.drawing.font = font
               preferences.drawing.foregroundColor = .clear
               preferences.drawing.backgroundColor = backgroundColor
               preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
               preferences.drawing.arrowHeight = 8
               preferences.drawing.cornerRadius = 12
               preferences.drawing.arrowWidth = 15
    //           preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
               preferences.animating.showInitialAlpha = 0
               preferences.animating.showDuration = 1.0//1.5
               preferences.animating.dismissDuration = 1.0//1.5
               easyTipView = EasyTipView(text: text, preferences: preferences)
              guard let easyTopViewUnrapped = easyTipView else {return}
              easyTopViewUnrapped.show(forView: sticker, withinSuperview: view)
              sticker.textView.layer.borderWidth = 2.8//4
              sticker.textView.layer.borderColor = sticker.stickerTextColor.cgColor
        
        
        
        let stackView = UIStackView(arrangedSubviews: [editButton, setDurationButton, deleteButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    
        
        easyTopViewUnrapped.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))

            
        easyTopViewUnrapped.addSubview(horizontalLineSeperatorView)
        horizontalLineSeperatorView.anchor(top: editButton.bottomAnchor, leading: easyTopViewUnrapped.leadingAnchor, bottom: nil, trailing: easyTopViewUnrapped.trailingAnchor, padding: .init(top: 0, left: 1, bottom: 0, right: 1), size: .init(width: 0, height: 0.8))
    
        
        easyTopViewUnrapped.addSubview(deleteBtnHorizontalLineSeperatorView)
        deleteBtnHorizontalLineSeperatorView.anchor(top: setDurationButton.bottomAnchor, leading: easyTopViewUnrapped.leadingAnchor, bottom: nil, trailing: easyTopViewUnrapped.trailingAnchor, padding: .init(top: 0, left: 1, bottom: 0, right: 1), size: .init(width: 0, height: 0.8))
        
//        editButton.backgroundColor = .green
//        setDurationButton.backgroundColor = .blue
//        deleteButton.backgroundColor = .red
//
            
           }
    
    
    @objc func dismissEasyTipView() {
           easyTipView?.dismiss()
           easyTipView = nil
           allStickers.forEach { (sticker) in
             sticker.layer.borderWidth = 0
               sticker.layer.borderColor = UIColor.clear.cgColor
               sticker.textView.layer.borderWidth = 0
              sticker.textView.layer.borderColor = UIColor.clear.cgColor
           }
       }
    
    
    
    func handleSetUpButtonImageView(button: UIButton, buttonWidth: CGFloat, topInset: CGFloat, paddingLeft: CGFloat) {
        button.imageView?.constrainHeight(constant: buttonWidth)
        button.imageView?.constrainWidth(constant: buttonWidth)
        button.imageView?.constrainToLeft(paddingLeft: paddingLeft) //20
        button.imageView?.centerYInSuperview()
        guard let imageView = button.imageView else {return}
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 0).isActive = true
        button.titleEdgeInsets = .init(top: topInset, left: 0, bottom: 0, right: 0)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        
    }
           
}



