//
//  MainTabBarController.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/6/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import FirebaseAuth
class MainTabBarController: UITabBarController {
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        handleSetUpViewControllers()
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        delegate = self
        setTabBarToTransparent()
        checkIfUserIsLoggedIn()
//
//          let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//        }

    }
    
    
    //MARK: - Properties
    let tabBarSeperatorTopLine: CALayer = {
       let tabBarTopLine = CALayer()
        tabBarTopLine.backgroundColor = UIColor.clear.cgColor
       return tabBarTopLine
   }()
    
    
    
    let progressView: UIProgressView = {
       let progressView = UIProgressView()
       progressView.progressTintColor = UIColor.white
       progressView.trackTintColor = UIColor.lightGray
       progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.5)
       return progressView
    }()
    
    
    
    //MARK: - Tabbar Delegates
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
           let index = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0))!
           item.tag = index
        if index == 0 {
           setTabBarToTransparent()
            progressView.alpha = 1
            tabBarSeperatorTopLine.backgroundColor = UIColor.clear.cgColor
        }  else {
            restoreTabBar()
            progressView.alpha = 0
            tabBarSeperatorTopLine.backgroundColor = UIColor.lightGray.cgColor
        }
    }

    

    
    //MARK: - Handlers

    func handleSetUpViewControllers() {
        let selectedFeedImage = UIImage(named: "homeFeedSelected")!.withRenderingMode(.alwaysTemplate)
        let feedImage = UIImage(named: "homeFeedSelected")!.withRenderingMode(.alwaysTemplate)
        
        
        let homeViewController = handleNavigationControllers(controller: HomeFeedController(), selectedImage: selectedFeedImage, image: feedImage, title: "Home")
        
        let searchSelectedImage = UIImage(named: "searchSelected")!.withRenderingMode(.alwaysTemplate)
       let searchImage = UIImage(named: "searchSelected")!.withRenderingMode(.alwaysTemplate)
               
        
        
        let discoverViewController = handleNavigationControllers(controller: DiscoverVC(collectionViewLayout: UICollectionViewFlowLayout()), selectedImage: searchSelectedImage, image: searchImage, title: "Discover")
        
        
        let createPostSelectedImage = UIImage(named: "song")!.withRenderingMode(.alwaysTemplate)
             let createPostImage = UIImage(named: "song")!.withRenderingMode(.alwaysTemplate)

        
        let createPostViewController = handleNavigationControllers(controller: UIViewController(), selectedImage: createPostSelectedImage, image: createPostImage, title: nil)
        
        
        let notificationsSelectedImage = UIImage(named: "notificationsSelectedImage")!.withRenderingMode(.alwaysTemplate)
       let notificationsImage = UIImage(named: "notificationsSelectedImage")!.withRenderingMode(.alwaysTemplate)
                     
               
//        let noAuthNotificationsVC = AuthViewController(imageViewIcon: UIImage(named: "chat (3)")!, signUpLabelText: "Messages and notifications will appear here", navTitle: "All activity")
        let notificationsViewController = handleNavigationControllers(controller: NotificationsVC(), selectedImage: notificationsSelectedImage, image: notificationsImage, title: "Inbox")
        
        
        let profileSelectedImage = UIImage(named: "profileSelectedImage")!.withRenderingMode(.alwaysTemplate)
              let profileImage = UIImage(named: "profileSelectedImage")!.withRenderingMode(.alwaysTemplate)
                  
        let noAuthProfileVC = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())//AuthViewController(imageViewIcon: UIImage(named: "user")!, signUpLabelText: "Sign up for an account", navTitle: "Profile")

        let profileViewController = handleNavigationControllers(controller: noAuthProfileVC, selectedImage: profileSelectedImage, image: profileImage, title: "Me")
        
        
        tabBarSeperatorTopLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        tabBar.layer.addSublayer(tabBarSeperatorTopLine)
        tabBar.clipsToBounds = true

           
        view.insertSubview(progressView, aboveSubview: tabBar)
        progressView.constrainToLeft(paddingLeft: -3)
        progressView.constrainToRight(paddingRight: 3)
        progressView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        
        
        handleFetchCurrentUser()
        viewControllers = [homeViewController, discoverViewController, createPostViewController, notificationsViewController, profileViewController]
        
        guard let items = self.tabBar.items else {return}
        for (index, element) in items.enumerated() {
            if index == 2 {
                element.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
        }

    }
    
    
    func handleNavigationControllers(controller: UIViewController, selectedImage: UIImage, image: UIImage, title: String?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.title = title
        return navController
    }
    
    
    
  
    
    func setTabBarToTransparent() {
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.shadowImage = UIImage() //this removes the tabbar controller's top line
    }
    
    
    
    func restoreTabBar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = .white
    }
    
    
    
    func checkIfUserIsLoggedIn() {
           if Auth.auth().currentUser == nil {
               
               DispatchQueue.main.async {
                   self.handlePresentLoginVc()
                
               }
           } else {
              handleSetUpViewControllers()
           }
       }
    
    
    fileprivate func handlePresentLoginVc() {
        let authVC = AuthViewController(authType: .signUp)
        let navController = UINavigationController(rootViewController: authVC)
        navController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        present(navController, animated: true, completion: nil)
    }
    
}


//MARK: - UITabBarControllerDelegate
extension MainTabBarController : UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let createPostVC = CreatePostVC()
//            createPostVC.modalPresentationStyle = .fullScreen
            let navController = UINavigationController(rootViewController: createPostVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
