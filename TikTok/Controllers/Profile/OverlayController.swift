//
//  OverlayController.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
public let baseWhiteColor = UIColor.rgb(red: 234, green: 236, blue: 238)
class OverlayController: UIViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        handleSetUpPanGesture()
    }
    
    
    //MARK: - Properties
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    
    fileprivate let topLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        return view
    }()
    
    
    fileprivate let horizontalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    let navBarTitle: UILabel = {
        let label = UILabel()
        label.text = "Select a Tag to Explore"
        label.font = defaultFont(size: 17)
        label.textAlignment = .center
        return label
    }()
    
    

    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.addSubview(horizontalBarView)
        horizontalBarView.constrainToTop(paddingTop: 8)
        horizontalBarView.centerXInSuperview()
        horizontalBarView.constrainHeight(constant: 5)
        horizontalBarView.constrainWidth(constant: 40)
        
        view.addSubview(topLineSeperatorView)
        topLineSeperatorView.anchor(top: horizontalBarView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 45, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
        
        view.addSubview(navBarTitle)
        navBarTitle.anchor(top: horizontalBarView.bottomAnchor, leading: view.leadingAnchor, bottom: topLineSeperatorView.topAnchor, trailing: view.trailingAnchor)
        
               
               
    }
    
    
    
    func handleSetUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 500 { //1300 S.B
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}


