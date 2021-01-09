//
//  NotificationsVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
fileprivate let cellReUseIdentiffier = "tableViewTikTokID"
class NotificationsVC: UIViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        handleSetUpNavItem()
    }
    
    
    //MARK: - Properties
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    fileprivate lazy var containerViewHeight = view.frame.height / 2
    fileprivate lazy var containerView: NotificationsNavBarView = {
        let containerView = NotificationsNavBarView()
        containerView.transform = view.transform.translatedBy(x: 0, y: -containerViewHeight)
        containerView.delegate = self
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 4
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner] //top right .layerMaxXMinYCorner // bottom right layerMaxXMaxYCorner
        return containerView
    }()
    
    
    fileprivate lazy var topDimmedView: UIView = {
        let blackAlphaView = UIView()
        blackAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        blackAlphaView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerViewVisibility))
        blackAlphaView.isUserInteractionEnabled = true
        blackAlphaView.addGestureRecognizer(tapGesture)
        return blackAlphaView
    }()
    
    
    fileprivate lazy var bottomDimmedView: UIView = {
        let blackAlphaView = UIView()
        blackAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        blackAlphaView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerViewVisibility))
        blackAlphaView.isUserInteractionEnabled = true
        blackAlphaView.addGestureRecognizer(tapGesture)
        return blackAlphaView
    }()
    
    
    fileprivate lazy var tapGesture : UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerViewVisibility))
        return tapGesture
    }()
    
    
    fileprivate lazy var navBarContainerView: UIView = {
        let navBarContainerView = UIView()
        navBarContainerView.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerViewVisibility))
        navBarContainerView.isUserInteractionEnabled = true
        navBarContainerView.addGestureRecognizer(tapGesture)
        return navBarContainerView
    }()
    
    
    fileprivate let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "All activity"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)//defaultFont(size: 16.5)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    fileprivate let expandArrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "expandArrowIcon")?.withRenderingMode(.alwaysOriginal)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: cellReUseIdentiffier)
        
       if let window = UIApplication.shared.keyWindow {
           view.addSubview(topDimmedView)
           topDimmedView.fillSuperview()
           
           window.addSubview(bottomDimmedView)
           let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 50;
           bottomDimmedView.anchor(top: nil, leading: window.leadingAnchor, bottom: window.bottomAnchor, trailing: window.trailingAnchor, size: .init(width: 0, height: tabBarHeight))
             
       }
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size:  .init(width: 0, height: containerViewHeight))
        
        
    }
    
    
    fileprivate func handleSetUpNavItem() {
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.addSubview(navBarContainerView)
        navBarContainerView.centerInSuperview(size: .init(width: 200, height: navBar.frame.height))
        navBarContainerView.addSubview(navTitleLabel)
        navTitleLabel.centerInSuperview()
        
        navBarContainerView.addSubview(expandArrowIconImageView)
        expandArrowIconImageView.centerYInSuperview()
        expandArrowIconImageView.leadingAnchor.constraint(equalTo: navTitleLabel.trailingAnchor, constant: 5).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cursor (1)")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: nil)

//        navTitleLabel.backgroundColor = .red
//        handleHide_ShowNavLine(navController: navigationController, showLine: false)
        
        
    }
    
    
    
    @objc func handleContainerViewVisibility() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else {return}
            //hides
            if self.containerView.transform == CGAffineTransform.identity {
                self.containerView.transform = CGAffineTransform.init(translationX: 0, y: -self.containerViewHeight)
                self.topDimmedView.alpha = 0
                self.bottomDimmedView.alpha = 0
                self.expandArrowIconImageView.handleRotate180(rotate: false)

            } else {
                //shows
                self.containerView.transform = .identity
                self.topDimmedView.alpha = 1
                self.bottomDimmedView.alpha = 1
                self.expandArrowIconImageView.handleRotate180(rotate: true)
                

            }
        })
        
        
    }
}




//MARK: - TableView Delegates & DataSource
extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentiffier, for: indexPath) as! NotificationsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if indexPath.item == 0 || indexPath.item == 3 {
            cell.setUpFollowButton()
        } else {
            cell.setUpPostImageView()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    
}



 //MARK: - NotificationsNavBarViewDelegate
extension NotificationsVC: NotificationsNavBarViewDelegate {
    func didSelectNotification(type: NotificationType) {
        navTitleLabel.text = type.title
        handleContainerViewVisibility()
    }
}
