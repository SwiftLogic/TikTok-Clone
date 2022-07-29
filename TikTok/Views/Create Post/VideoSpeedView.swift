//
//  VideoSpeedView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 4/11/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
//MARK: CONTINUE HERE and set the player rate in parent vc
//also fix the slow loading of create postvc when you first tap it. the solution is to lazy load our media
protocol VideoSpeedViewDelegate: class {
    func didChangeVideoPlayRate(with rate: Float)
}
class VideoSpeedView: UIView {

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        clipsToBounds = true
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit VideoSpeedView")
    }
    
    
    //MARK: - Properties
    weak var delegate: VideoSpeedViewDelegate?
    
        
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel, thirdLabel, fourthLabel, fivethLabel])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    fileprivate lazy var firstLabel = handleCreateLabel(text: "0.3x")
    
    fileprivate lazy var secondLabel = handleCreateLabel(text: "0.5x")
    
    fileprivate lazy var thirdLabel = handleCreateLabel(text: "1x")
    
    fileprivate lazy var fourthLabel = handleCreateLabel(text: "2x")
    
    fileprivate lazy var fivethLabel = handleCreateLabel(text: "3x")

    fileprivate lazy var selectedLabel = handleCreateLabel(text: "1x")

    static let stackViewHeight: CGFloat = 40
    
    //MARK: - Handlers
    
    fileprivate func handleCreateLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.font = defaultFont(size: 16.5)
        label.constrainHeight(constant: VideoSpeedView.stackViewHeight)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        label.addGestureRecognizer(tapGesture)
        return label
    }
    
    
    fileprivate func setUpViews() {
        addSubview(stackView)
        stackView.fillSuperview()
        //
        stackView.addSubview(selectedLabel)
        selectedLabel.centerXInSuperview()
        selectedLabel.centerYInSuperview()
        selectedLabel.constrainHeight(constant: VideoSpeedView.stackViewHeight)
        selectedLabel.widthAnchor.constraint(equalTo: thirdLabel.widthAnchor).isActive = true
        selectedLabel.backgroundColor = .white
        selectedLabel.textColor = .gray
        selectedLabel.clipsToBounds = true
        selectedLabel.layer.cornerRadius = 2.5
    }
    
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        selectedLabel.text = label.text!
        triggerHapticFeedback()
        handleGetPlayRate(from: label.text!)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak self] in
            self?.selectedLabel.center = label.center
        }
    }
    
    
    fileprivate func handleGetPlayRate(from text: String) {
        let playRateString = text
        
        switch playRateString {
        
        case "0.3x":
            delegate?.didChangeVideoPlayRate(with: 0.3)
            
        case "0.5x":
            delegate?.didChangeVideoPlayRate(with: 0.5)

        case "1x":
            delegate?.didChangeVideoPlayRate(with: 1)

        case "2x":
            delegate?.didChangeVideoPlayRate(with: 1.5)

        case "3x":
            delegate?.didChangeVideoPlayRate(with: 2)
        default:
        print("playRateString: default")
            
        }
    }
    
    
   
}
