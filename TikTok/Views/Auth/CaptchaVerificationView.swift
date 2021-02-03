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
        backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        clipsToBounds = true
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: - Properties
    private var startLocation: CGPoint = .zero
    private var startFrame: CGRect = .zero
    private var originalWidth: CGFloat = 55

    fileprivate let verificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Verification"
        label.font = avenirRomanFont(size: 16.5)
        return label
    }()
    
    
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
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
    
    
    
    
    
    
     fileprivate let draggableArrowView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(swipeRightArrow_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
        button.imageView?.constrainHeight(constant: 25)
        button.imageView?.constrainWidth(constant: 25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        return button
       }()
    
    
    
    fileprivate let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(swipeRightArrow_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
//        button.imageView?.centerInSuperview(size: .init(width: 40, height: 40))
           return button
       }()
    
    
    
    fileprivate let reportAProblemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Report a problem", for: .normal)
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
    
    
    private var tailWindViewTrailingAnchor: NSLayoutConstraint?
    private var draggableViewLeadingAnchor: NSLayoutConstraint?

    fileprivate let tailWindView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    
    fileprivate let dragToSolvePuzzleView: UIView = {
       let view = UIView()
       view.backgroundColor = .yellow
       view.isUserInteractionEnabled = true
       return view
   }()
    
    
    fileprivate let finalPuzzleViewToDragTo: UIView = {
       let view = UIView()
       view.backgroundColor = .red
       view.isUserInteractionEnabled = true
       return view
   }()
       
       
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        backgroundColor = .white
        addSubview(verificationLabel)
        addSubview(cancelButton)
        addSubview(imageView)
        
        addSubview(bottomView)
        
        addSubview(draggableArrowView)
        addSubview(dragToSlideLabel)
        insertSubview(tailWindView, belowSubview: draggableArrowView)
        
        
        addSubview(dragToSolvePuzzleView)
        imageView.addSubview(finalPuzzleViewToDragTo)
        
        verificationLabel.constrainToTop(paddingTop: 8)
        verificationLabel.constrainToLeft(paddingLeft: 10)
        
        
        cancelButton.constrainToTop(paddingTop: 5)
        cancelButton.constrainToRight(paddingRight: -10)
        
        imageView.anchor(top: verificationLabel.bottomAnchor, leading: verificationLabel.leadingAnchor, bottom: bottomView.topAnchor, trailing: cancelButton.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        
        bottomView.anchor(top: nil, leading: imageView.leadingAnchor, bottom: bottomAnchor, trailing: imageView.trailingAnchor, size: .init(width: 0, height: 48))
        
        
        draggableArrowView.anchor(top: bottomView.topAnchor, leading: nil, bottom: bottomView.bottomAnchor, trailing: nil, padding: .init(top: 1.5, left: 1.5, bottom: 1.5, right: 0), size: .init(width: 55, height: 0))
        
        draggableViewLeadingAnchor = draggableArrowView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 1.5)
        draggableViewLeadingAnchor?.isActive = true
        
        
        dragToSlideLabel.anchor(top: nil, leading: bottomView.leadingAnchor, bottom: nil, trailing: bottomView.trailingAnchor, padding: .init(top: 0, left: 65, bottom: 0, right: 0))
        dragToSlideLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        
        
       tailWindView.anchor(top: bottomView.topAnchor, leading: imageView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: nil, padding: .init(top: 1.5, left: 1.5, bottom: 1.5, right: 0))

        tailWindViewTrailingAnchor = tailWindView.trailingAnchor.constraint(equalTo: draggableArrowView.trailingAnchor)
        tailWindViewTrailingAnchor?.isActive = true
        
        
        
        dragToSolvePuzzleView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        dragToSolvePuzzleView.leadingAnchor.constraint(equalTo: draggableArrowView.leadingAnchor, constant: 0).isActive = true
        dragToSolvePuzzleView.constrainHeight(constant: 65)
        dragToSolvePuzzleView.constrainWidth(constant: 65)
        
        
        finalPuzzleViewToDragTo.centerInSuperview(size: .init(width: 65, height: 65))
        
        
        [panGesture].forEach {(gesture) in draggableArrowView.addGestureRecognizer(gesture)}

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            self.dragToSlideLabel.startShimmeringAnimation()

        }


    }
    
    
    
    //MARK: - Target Selectors
    
    private func clampFrame(_ frame: CGRect, inBounds bounds: CGRect) -> CGRect {
        let center: CGPoint = CGPoint(x: max(bounds.minX + frame.width*0.5, min(frame.midX, bounds.maxX - frame.width*0.5)),
                                      y: max(bounds.minY + frame.height*0.5, min(frame.midY, bounds.maxY - frame.height*0.5)))
        return CGRect(x: center.x-frame.width*0.5, y: center.y-frame.height*0.5, width: frame.width, height: frame.height)
    }
    
    
    

   private func moveFrame(_ frame: CGRect, by translation: CGPoint, constrainedTo bounds: CGRect) -> CGRect {
        var newFrame = frame
        newFrame.origin.x += translation.x
        newFrame.origin.y += translation.y
        return clampFrame(newFrame, inBounds: bounds)
    }

   
    //Note: - Solution derived from https://stackoverflow.com/questions/55488511/how-to-set-boundaries-of-dragging-control-using-uipangesturerecognizer
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else { return }

        if gestureRecognizer.state == .began {
            startLocation = gestureRecognizer.location(in: bottomView)
            startFrame = gestureView.frame
            
        } else if gestureRecognizer.state == .changed {
            let newLocation = gestureRecognizer.location(in: bottomView)
            let translation = CGPoint(x: newLocation.x-startLocation.x, y: 0) //this only allows horizontal translation
            gestureView.frame = moveFrame(startFrame, by: translation, constrainedTo: bottomView.frame)

//            tailWindViewTrailingAnchor?.constant = originalWidth + translation.x
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


