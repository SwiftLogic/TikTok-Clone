//
//  SetDurationContainerView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 3/3/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import PryntTrimmerView
import AVKit
import SVProgressHUD
class SetDurationContainerView: UIView {
    
    //MARK: - Init
    
    
    //this how to do a custom init
    required init(videoUrl: URL) {
        self.videoUrl = videoUrl
        super.init(frame: CGRect.zero)
        setUpViews()
        setUpViewCustomizations()
        handleSetTrimmerAsset()

    }
    
    
    
    //MARK: - Properties
    var didTapDismissView: (() -> Void?)?
    
   fileprivate var videoUrl: URL
    
    fileprivate let selectedDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "Selected sticker lasts for 28.2s"
        label.textColor = .white
        label.font = defaultFont(size: 14)
        return label
    }()
    
    
    fileprivate let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "Duration"
        label.textColor = .white
        label.textAlignment = .center
        label.font = defaultFont(size: 15.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(play_ic_filled?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(saveVideoCheckmarkIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    fileprivate let bottomLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        return view
    }()
    
    
    
    fileprivate lazy var cancelButtonTapGestureView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCancelButton))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    
    fileprivate lazy var doneButtonTapGestureView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCancelButton))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    
    
    lazy var trimmerView: TrimmerView = {
        let trimmerView = TrimmerView()
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = tikTokRed
        trimmerView.positionBarColor = .white
        trimmerView.translatesAutoresizingMaskIntoConstraints = false
        trimmerView.layer.cornerRadius = 5
        trimmerView.clipsToBounds = true
        trimmerView.maxDuration = Double(Int.max)// means no limit
//        trimmerView.delegate = self
        trimmerView.minDuration = 3
        return trimmerView
    }()
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(selectedDurationLabel)
        addSubview(playButton)
        addSubview(trimmerView)
        addSubview(bottomLineSeperator)
        addSubview(cancelButton)
        addSubview(cancelButtonTapGestureView)
        addSubview(doneButton)
        addSubview(doneButtonTapGestureView)
        addSubview(durationLabel)
        
        let sidePadding: CGFloat = 18
        selectedDurationLabel.constrainToTop(paddingTop: 20)
        selectedDurationLabel.constrainToLeft(paddingLeft: sidePadding)
        
        playButton.constrainToRight(paddingRight: -sidePadding)
        playButton.centerYAnchor.constraint(equalTo: selectedDurationLabel.centerYAnchor).isActive = true
        playButton.constrainHeight(constant: 20)
        playButton.constrainWidth(constant: 20)
        
        
        trimmerView.anchor(top: selectedDurationLabel.bottomAnchor, leading: selectedDurationLabel.leadingAnchor, bottom: nil, trailing: playButton.trailingAnchor, padding: .init(top: 25, left: 8, bottom: 0, right: 5), size: .init(width: 0, height: 45))
        
        
        bottomLineSeperator.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 55, right: 0), size: .init(width: 0, height: 0.3))
        
        
        let bottomPadding: CGFloat = -17.5
        let buttonDimen: CGFloat = 18.5
        cancelButton.leadingAnchor.constraint(equalTo: selectedDurationLabel.leadingAnchor).isActive = true
        cancelButton.constrainToBottom(paddingBottom: bottomPadding)
        cancelButton.constrainHeight(constant: buttonDimen)
        cancelButton.constrainWidth(constant: buttonDimen)
        
        let tapGestureViewWidth: CGFloat = 60
        
        cancelButtonTapGestureView.anchor(top: bottomLineSeperator.topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, size: .init(width: tapGestureViewWidth, height: 0))

        
        
        doneButton.trailingAnchor.constraint(equalTo: playButton.trailingAnchor).isActive = true
        doneButton.constrainToBottom(paddingBottom: bottomPadding)
        doneButton.constrainHeight(constant: buttonDimen)
        doneButton.constrainWidth(constant: buttonDimen)
        
        
        doneButtonTapGestureView.anchor(top: bottomLineSeperator.topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: tapGestureViewWidth, height: 0))
        
        durationLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor).isActive = true
        durationLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        
                          
    }
    
    
    fileprivate func setUpViewCustomizations() {
        backgroundColor = UIColor.rgb(red: 27, green: 27, blue: 27)
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] //layerMinXMinYCorner = top left, layerMaxXMinYCorner = top left
    }
    
    
    fileprivate func handleSetTrimmerAsset() {
        let asset = AVAsset(url: videoUrl)
        DispatchQueue.main.async {
            self.trimmerView.asset = asset 
        }
    }
    
    fileprivate var videoThumbnails: [UIImage] = [UIImage]()
    func handleExtracVideoFrames() {
           
          let asset = AVAsset(url: videoUrl)
          let duration = asset.duration
          let seconds = CMTimeGetSeconds(duration)
          let addition = seconds / 15
          var number = 1.0
          let imageGenerator = AVAssetImageGenerator(asset: asset)

          var times = [NSValue]()
          times.append(NSValue(time: CMTimeMake(value: Int64(number), timescale: 1)))
          while number < seconds {
              number += addition
              times.append(NSValue(time: CMTimeMake(value: Int64(number), timescale: 1)))
          }

          
          imageGenerator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, cgImage, actualImageTime, status, error) in

              let seconds = CMTimeGetSeconds(requestedTime)
              let date = Date(timeIntervalSinceNow: seconds)
              let time = Formatter.formatter.string(from: date)

              switch status {
              case .succeeded: do {
                      if let image = cgImage {
                          print("Generated image for approximate time: \(time)")

                       DispatchQueue.main.async {
                            let img = UIImage(cgImage: image)
                             self.videoThumbnails.append(img)
                                                 //do something with `img`
                       }
                         
                      }
                      else {
                          print("Failed to generate a valid image for time: \(time)")
                      }
                  }

              case .failed: do {
                      if let error = error {
                          print("Failed to generate image with Error: \(error) for time: \(time)")
                      }
                      else {
                          print("Failed to generate image for time: \(time)")
                      }
                  }

              case .cancelled: do {
                  print("Image generation cancelled for time: \(time)")
                  }
              }
          }
       }
    
    
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapCancelButton() {
        didTapDismissView?()
    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



struct Formatter {
    static let formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        return result
    }()
}


