//
//  AuthViewController.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class AuthViewController: UIViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        
    }
    
    
    
    init(imageViewIcon: UIImage, signUpLabelText: String, navTitle: String) {
        imageView.image = imageViewIcon.withRenderingMode(.alwaysTemplate)
        signUpLabel.text = signUpLabelText
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = navTitle

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    fileprivate let signUpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = avenirRomanFont(size: 14.5)
        label.numberOfLines = 0
        return label
    }()
    
    
    fileprivate let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightRed
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.titleLabel?.font = defaultFont(size: 14.5)
        return button
    }()
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        
        view.addSubview(signUpButton)
        view.addSubview(signUpLabel)
        view.addSubview(imageView)
        
        let spacing = view.frame.width * 0.20
        let width = view.frame.width - spacing
//        signUpButton.centerInSuperview(size: .init(width: width, height: 45))
        signUpButton.centerXInSuperview()
        signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive  = true
        signUpButton.constrainWidth(constant: width)
        signUpButton.constrainHeight(constant: 45)
        
        signUpLabel.anchor(top: nil, leading: signUpButton.leadingAnchor, bottom: signUpButton.topAnchor, trailing: signUpButton.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 20, right: 8))
        
        imageView.centerXAnchor.constraint(equalTo: signUpLabel.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: signUpLabel.topAnchor, constant: -20).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
