//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/14/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
fileprivate let cellReuseIdentifier = "cellReuseIdentifier"
fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    //MARK: - Init

    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpTabbarVisibility()
        setUpNavItems()
        self.currentUser = CURRENT_USER
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tabBarWasVisibleOnViewDidLoad == true {
            handleUnHideTabbar()
            navigationController?.navigationBar.isHidden = false
//            navigationItem.prompt = ""; // this adds empty space on top
        }
    }
    
    
   
    
    
    //MARK: - Properties
    
   fileprivate var tabBarWasVisibleOnViewDidLoad = true
    
//    override var prefersStatusBarHidden: Bool {
//      return false
//    }
//
    
    
     var currentUser: User? {
        didSet {
            navigationItem.title = currentUser?.username//handleSetUpUsers().username
        }
    }
    
    

    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpCollectionView() {
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    
    fileprivate func setUpNavItems() {
        navigationController?.setNavigationBarBorderColor(.clear) //removes navline
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(handleCustomPresentations))
    }
    
    
    fileprivate func handleUnHideTabbar() {
       if tabBarController?.tabBar.isHidden == true {
           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
               self?.tabBarController?.tabBar.isHidden = false

           })
       }
     }
    
    
    fileprivate func setUpTabbarVisibility() {
        if tabBarController?.tabBar.isHidden == true {
            tabBarWasVisibleOnViewDidLoad = false
        } else {
            tabBarWasVisibleOnViewDidLoad = true
        }
    }
    
    
    
    
    
    func handleSetUpUsers() -> TikTokUser {
      let profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/imessage-f5d42.appspot.com/o/message_images%2Ffd02304e-6875-4c6a-a75c-d387f453077d?alt=media&token=b5d716eb-dd6e-4349-8a64-b246a820410e"
        
      let dict = ["username" : "@memes", "queryUsername": "@memes", "email": "memes@gmail.com", "profileImageUrl": profileImageUrl, "followersCount": 120, "followingCount": 71, "likes": 608, "bio": "Greetings hahahh", "postCount": 1000] as [String : Any]
      let user = TikTokUser(uid: "1", dictionary: dict)
        
      return user
    }

    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}



//MARK: - CollectionView Protocols
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ProfileCell
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 1
        return .init(width: width, height: width * 1.5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ProfileHeader
        header.user = handleSetUpUsers()
        return header
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let tiktokDetailsVC = TikTokDetailsVC(collectionViewLayout: layout)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(tiktokDetailsVC, animated: true)
    }
    
    
    
    @objc func handleCustomPresentations() {
        let slideVC = OverlayController()
       slideVC.modalPresentationStyle = .custom
       slideVC.transitioningDelegate = self
       self.present(slideVC, animated: true, completion: nil)
    }
    
    
   
    
}


extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}



extension UINavigationController {
    
    func setNavigationBarBorderColor(_ color:UIColor) {
        self.navigationBar.shadowImage = color.as1ptImage()
    }
}

extension UIColor {
    
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
