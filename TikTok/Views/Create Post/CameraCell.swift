//
//  CameraCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 10/29/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class CameraCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = .black//UIColor.green.withAlphaComponent(0.5)

    }
    
    
    
    
    //MARK: - Properties
    
    
    let effectsButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(effectsIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
       return button
   }()

       
   fileprivate let captureButtonDimension: CGFloat = 68
    
   lazy var captureButton: UIButton = {
       let button = UIButton(type: .system)
       button.backgroundColor = UIColor.rgb(red: 254, green: 44, blue: 85)
       button.clipsToBounds = true
       button.layer.cornerRadius = captureButtonDimension / 2
       return button
   }()
    
    
    let captureButtonRingView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.rgb(red: 254, green: 44, blue: 85).withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 6
        view.layer.cornerRadius = 85 / 2
        view.clipsToBounds = true
        return view
    }()

    
    
    let rightGuildeLineView: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        return view
    }()
    
    
    let leftGuildeLineView: UIView = {
       let view = UIView()
//       view.backgroundColor = .red
       return view
   }()

   let openPhotosButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(landscapeIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
       return button
   }()

    
    
    let effectsLabel: UILabel = {
        let label = UILabel()
        label.text = "Effects"
        label.font = defaultFont(size: 12.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uploadLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload"
        label.font = defaultFont(size: 12.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(captureButtonRingView)
        
        captureButtonRingView.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 65, right: 0), size: .init(width: 85, height: 85))
        captureButtonRingView.centerXInSuperview()
        
        captureButtonRingView.addSubview(captureButton)
        captureButton.centerInSuperview(size: .init(width: 68, height: 68))
        
        addSubview(rightGuildeLineView)
        rightGuildeLineView.anchor(top: captureButtonRingView.topAnchor, leading: captureButtonRingView.trailingAnchor, bottom: captureButtonRingView.bottomAnchor, trailing: trailingAnchor)
        
        addSubview(leftGuildeLineView)
        leftGuildeLineView.anchor(top: captureButtonRingView.topAnchor, leading: leadingAnchor, bottom: captureButtonRingView.bottomAnchor, trailing: captureButtonRingView.leadingAnchor)
        
        rightGuildeLineView.addSubview(openPhotosButton)
        openPhotosButton.centerInSuperview()

        
        leftGuildeLineView.addSubview(effectsButton)
        effectsButton.centerInSuperview()
        
        rightGuildeLineView.addSubview(uploadLabel)
        uploadLabel.topAnchor.constraint(equalTo: openPhotosButton.bottomAnchor, constant: 2.5).isActive = true
        uploadLabel.centerXAnchor.constraint(equalTo: openPhotosButton.centerXAnchor).isActive = true

        
        
       leftGuildeLineView.addSubview(effectsLabel)
        effectsLabel.topAnchor.constraint(equalTo: effectsButton.bottomAnchor, constant: 2.5).isActive = true
       effectsLabel.centerXAnchor.constraint(equalTo: effectsButton.centerXAnchor).isActive = true



    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
