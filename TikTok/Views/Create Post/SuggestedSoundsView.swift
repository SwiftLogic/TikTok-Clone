//
//  SuggestedSoundsView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 5/2/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
protocol SuggestedSoundsViewDelegate: AnyObject {
    func didTapSearchForMoreSounds()
    func didTapAdjustClips()
}
class SuggestedSoundsView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = grayBackgroundColor
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    weak var delegate: SuggestedSoundsViewDelegate?
    let grayBackgroundColor = UIColor.rgb(red: 27, green: 27, blue: 27)
    lazy var trianglePointingView: TrianglePointingView = {
        let pointingView = TrianglePointingView()
        pointingView.translatesAutoresizingMaskIntoConstraints = false
        pointingView.fillColor = grayBackgroundColor
        pointingView.strokeColor = grayBackgroundColor
        return pointingView
    }()
    
    
    fileprivate let adjustClipButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14.5, weight: .medium, scale: .medium)
        let normalImage = UIImage(systemName: "slider.horizontal.below.square.fill.and.square", withConfiguration: symbolConfig)!
        button.setImage(normalImage, for: .normal)
        button.setTitle(" Adjust clip", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = appleNeoBold(size: 13.5)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 2.5
        button.addTarget(self, action: #selector(handleDidTapAdjustClip), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let suggestedSoundsLabel: UILabel = {
        let label = UILabel()
        label.text = "Suggested sounds"
        label.textColor = .white
        label.font = appleNeoBold(size: 14)
        return label
    }()
    
    
    fileprivate lazy var suggestedSoundsCollectionView: SuggestedSoundsCollectionView = {
        let suggestedSoundsCollectionView = SuggestedSoundsCollectionView()
        suggestedSoundsCollectionView.didTapSearchMoreSounds = {[weak self] in
            self?.delegate?.didTapSearchForMoreSounds()
        }
        return suggestedSoundsCollectionView
    }()
    
    
    
    fileprivate let adjustedClipsView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(trianglePointingView)
        trianglePointingView.anchor(top: nil, leading: leadingAnchor, bottom: topAnchor, trailing: nil, padding: .init(top: 0, left: 100, bottom: -10, right: 0), size: .init(width: 40, height: 20))

        
        addSubview(adjustClipButton)
        
        let padding: CGFloat = 12
        adjustClipButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: 0, bottom: 0, right: padding), size: .init(width: 110, height: 28))
        
        addSubview(suggestedSoundsLabel)
        suggestedSoundsLabel.constrainToLeft(paddingLeft: padding)
        suggestedSoundsLabel.centerYAnchor.constraint(equalTo: adjustClipButton.centerYAnchor).isActive = true
        
        
        addSubview(suggestedSoundsCollectionView)
        suggestedSoundsCollectionView.anchor(top: adjustClipButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    
    //MARK: Target Selectors
    @objc fileprivate func handleDidTapAdjustClip() {
        delegate?.didTapAdjustClips()
    }
}




