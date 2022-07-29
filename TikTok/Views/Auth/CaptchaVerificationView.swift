//
//  CaptchaVerificationView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 1/22/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class CaptchaVerificationView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        clipsToBounds = true
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: - Properties
    private var arrowWidth: CGFloat = 50//55
    private let arrowHeight: CGFloat = 40//48

    private var tailWindViewRightWidthAnchor = NSLayoutConstraint()
    private var tailWindWidthAnchor = NSLayoutConstraint()


    fileprivate let verificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Verification:"
        label.font = avenirRomanFont(size: 14.5)
        return label
    }()
    
    
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14.5, weight: .medium, scale: .medium)
        let normalImage = UIImage(systemName: "xmark", withConfiguration: symbolConfig)!
        button.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "natureCompelling"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    fileprivate let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        return view
    }()
    
    
    
    
    
    
     fileprivate let arrowboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(swipeRightArrow_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
        button.imageView?.constrainHeight(constant: 20) //25
        button.imageView?.constrainWidth(constant: 20) //25
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isUserInteractionEnabled = false
        return button
       }()
    
    
    
    fileprivate let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Refresh", for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14.5, weight: .medium, scale: .medium)
        let normalImage = UIImage(systemName: "arrow.clockwise", withConfiguration: symbolConfig)!
        button.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.5)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.5)
        return button
       }()
    
    
    
    fileprivate let reportAProblemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Report a problem", for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14.5, weight: .medium, scale: .medium)
        let normalImage = UIImage(systemName: "exclamationmark.circle", withConfiguration: symbolConfig)!
        button.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.5)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.5)
           return button
       }()
       
    
    fileprivate lazy var panGesture: UIPanGestureRecognizer = {
           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
           panGesture.maximumNumberOfTouches = 1
           panGesture.delegate = self
           return panGesture
       }()
    
    
    fileprivate let dragToSlideLabel: UILabel = {
        let label = UILabel()
        label.text = "Drag the slider to fit the puzzle piece"
        label.font = avenirRomanFont(size: 13.5)
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        return label
    }()
    
    
    private var draggableViewLeadingAnchor: NSLayoutConstraint?

    fileprivate let tailWindBackgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    
    fileprivate lazy var dragToSolvePuzzleView: UIImageView = {
        let view = UIImageView(image: puzzleZero!.withRenderingMode(.alwaysTemplate))
        view.backgroundColor = UIColor.green.withAlphaComponent(0.5)
       view.isUserInteractionEnabled = true
       let pangesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
       view.addGestureRecognizer(pangesture)
       view.clipsToBounds = true
       view.layer.cornerRadius = 4
        view.tintColor = .red
       return view
   }()
    
    
    fileprivate let finalPuzzleViewToDragTo: UIView = {
        let view = UIImageView(image: puzzleZeroFill!)
        view.backgroundColor = UIColor.green
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
       return view
   }()
       
       
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        backgroundColor = .white
        addSubview(verificationLabel)
        addSubview(cancelButton)
        addSubview(imageView)
        
        addSubview(bottomView)
        
        addSubview(tailWindBackgroundView)
        addSubview(dragToSlideLabel)
        addSubview(arrowboxButton)

        
        
        addSubview(dragToSolvePuzzleView)
        addSubview(finalPuzzleViewToDragTo)
        addSubview(refreshButton)
        addSubview(reportAProblemButton)
        
        
        verificationLabel.constrainToTop(paddingTop: 8)
        verificationLabel.constrainToLeft(paddingLeft: 10)
        
        
        cancelButton.constrainToTop(paddingTop: 5)
        cancelButton.constrainToRight(paddingRight: -10)
        
        imageView.anchor(top: verificationLabel.bottomAnchor, leading: verificationLabel.leadingAnchor, bottom: bottomView.topAnchor, trailing: cancelButton.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        
        bottomView.anchor(top: nil, leading: imageView.leadingAnchor, bottom: bottomAnchor, trailing: imageView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 40, right: 0), size: .init(width: 0, height: arrowHeight))
        
        
        dragToSlideLabel.anchor(top: nil, leading: bottomView.leadingAnchor, bottom: nil, trailing: bottomView.trailingAnchor, padding: .init(top: 0, left: 65, bottom: 0, right: 0))
        dragToSlideLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        
        
       tailWindBackgroundView.anchor(top: bottomView.topAnchor, leading: imageView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: nil, padding: .init(top: 1.5, left: 1.5, bottom: 1.5, right: 0))
        
        

        tailWindViewRightWidthAnchor = tailWindBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        tailWindViewRightWidthAnchor.isActive = false
        
        tailWindWidthAnchor = tailWindBackgroundView.widthAnchor.constraint(equalToConstant: arrowWidth)
        tailWindWidthAnchor.isActive = true
        
        
        arrowboxButton.anchor(top: bottomView.topAnchor, leading: nil, bottom: bottomView.bottomAnchor, trailing: nil, padding: .init(top: 1.5, left: 1.5, bottom: 1.5, right: 0), size: .init(width: arrowWidth + 2, height: 0))
        
        arrowboxButton.trailingAnchor.constraint(equalTo: tailWindBackgroundView.trailingAnchor, constant: 0).isActive = true
        
        
        
        dragToSolvePuzzleView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        dragToSolvePuzzleView.leadingAnchor.constraint(equalTo: arrowboxButton.leadingAnchor, constant: 0).isActive = true
        dragToSolvePuzzleView.constrainHeight(constant: 65)
        dragToSolvePuzzleView.constrainWidth(constant: 65)
        
        let randomRightPadding = CGFloat.random(in: 5...120)
        finalPuzzleViewToDragTo.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        finalPuzzleViewToDragTo.constrainToRight(paddingRight: -randomRightPadding)
        finalPuzzleViewToDragTo.constrainHeight(constant: 65)
        finalPuzzleViewToDragTo.constrainWidth(constant: 65)
        
        
        refreshButton.anchor(top: bottomView.bottomAnchor, leading: bottomView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        reportAProblemButton.anchor(top: bottomView.bottomAnchor, leading: refreshButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 12, bottom: 0, right: 0))

        
        [panGesture].forEach {(gesture) in tailWindBackgroundView.addGestureRecognizer(gesture)}

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            self.dragToSlideLabel.startShimmeringAnimation()

        }


    }
    
    
    
    //MARK: - Target Selectors
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        
        var newWidth = -(bottomView.frame.width - gestureRecognizer.location(in: bottomView).x)
        newWidth = max(-(bottomView.frame.width - arrowHeight), newWidth)
        newWidth = min(0, newWidth)
        tailWindViewRightWidthAnchor.constant = newWidth
        
        

        if gestureRecognizer.state == .began {
            tailWindBackgroundView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
            tailWindWidthAnchor.isActive = false
            tailWindViewRightWidthAnchor.isActive = true
            dragToSlideLabel.alpha = 0
            
        } else if gestureRecognizer.state == .ended {
            
            let puzzleSolved = dragToSolvePuzzleView.frame.contains(finalPuzzleViewToDragTo.frame)
            if puzzleSolved {
                triggerHapticFeedback()
                tailWindBackgroundView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
                
//                print("puzzle solved!")
            } else {
                tailWindBackgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                tailWindWidthAnchor.isActive = true
                tailWindViewRightWidthAnchor.isActive = false
                dragToSlideLabel.alpha = 1

                UIView.animate(withDuration: 0.5) {[weak self] in
                    self?.layoutIfNeeded()
                }
//                print("puzzle failed!")
            }
            
        }

        
        
        
        
        
    }
    

}




//MARK: - Shimmer View
extension UIView {
  
  // ->1
  enum Direction: Int {
    case topToBottom = 0
    case bottomToTop
    case leftToRight
    case rightToLeft
  }
  
  func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                direction: Direction = .leftToRight,
                                repeatCount: Float = MAXFLOAT) {
    
    // Create color  ->2
    let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
    let blackColor = UIColor.black.cgColor
    
    // Create a CAGradientLayer  ->3
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [blackColor, lightColor, blackColor]
    gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
    
    switch direction {
    case .topToBottom:
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
      
    case .bottomToTop:
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
      
    case .leftToRight:
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
      
    case .rightToLeft:
      gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
    }
    
    gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
    self.layer.mask = gradientLayer
    
    // Add animation over gradient Layer  ->4
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [0.0, 0.1, 0.2]
    animation.toValue = [0.8, 0.9, 1.0]
    animation.duration = CFTimeInterval(animationSpeed)
    animation.repeatCount = repeatCount
    CATransaction.setCompletionBlock { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.layer.mask = nil
    }
    gradientLayer.add(animation, forKey: "shimmerAnimation")
    CATransaction.commit()
  }
  
  func stopShimmeringAnimation() {
    self.layer.mask = nil
  }
  
}


