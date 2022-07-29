//
//  BaseHomeFeedCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/9/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
protocol BaseHomeFeedCellDelegate: AnyObject {
    func handleSetUpVideoPlayer(cell: VerticalFeedCell, videoUrlString: String)
    func didTapPlayButton(play: Bool)
}
class BaseHomeFeedCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    lazy var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    //handleCreatePosts()

    
    weak var delegate: BaseHomeFeedCellDelegate?
    var currentIndexPath = IndexPath(item: 0, section: 0)
    let verticalCellReuseIdentifier = "verticalCellReuseIdentifier"
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.register(VerticalFeedCell.self, forCellWithReuseIdentifier: verticalCellReuseIdentifier)
        collectionView.fillSuperview()
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension BaseHomeFeedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - CollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: verticalCellReuseIdentifier, for: indexPath) as! VerticalFeedCell
        cell.delegate = self
        cell.post = posts[indexPath.item]
//        let colors = [UIColor.red.withAlphaComponent(0.5), UIColor.brown, UIColor.green.withAlphaComponent(0.5), UIColor.blue.withAlphaComponent(0.5), UIColor.cyan.withAlphaComponent(0.5)]
//        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width, height: frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
   
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let pageNumber = Int(targetContentOffset.pointee.y / frame.height)
            let indexPath = IndexPath(item: pageNumber, section: 0)
            currentIndexPath = indexPath
        guard let cell = collectionView.cellForItem(at: indexPath) as? VerticalFeedCell else {return}
        delegate?.handleSetUpVideoPlayer(cell: cell, videoUrlString: posts[indexPath.item].videoUrl ?? "")
           
        }
}



//MARK: - VerticalFeedCellDelegate
extension BaseHomeFeedCell: VerticalFeedCellDelegate {
    func didTapCommentTextViewInCell(currentCell: VerticalFeedCell) {}
    func didTapCommentTextViewInCell() {}
    func handleDidTapExitController(cell: VerticalFeedCell) {}
    
    func didTapPlayButton(play: Bool) {
        delegate?.didTapPlayButton(play: play)
    }
    
    
    
    
    
    
    
   
    
//    fileprivate func handleCreatePosts() -> [Post] {
//
//        let postId: String = "1"
//        let postImageUrl: String = "https://firebasestorage.googleapis.com/v0/b/digmeproject.appspot.com/o/post_images%2F8C14C71E-44DE-4827-A70A-A81B9E6D1963?alt=media&token=4a9c47e0-1b87-4086-80a1-19a1eae2fda6"
//
//         let videoUrl: String? = "https://firebasestorage.googleapis.com/v0/b/digmeproject.appspot.com/o/post_videos%2FBD6417FC-F92B-4887-9AC5-0B54E3EE20B4.mov?alt=media&token=be97361f-ed7d-4fbc-9324-d45513359b94"
//        let caption: String? = "Hahaha wow dude come on fam"
//        let creationDate: Date = Date()
//
//         let likes: Int = 10000
//         let views: Int = 200000
//         let commentCount: Int = 17500
//        let ownerUid: String = CURRENT_UID ?? ""
//
//
//        let postDict = ["postId": postId, "postImageUrl": postImageUrl, "videoUrl": videoUrl, "caption": caption, "creationDate": creationDate, "likes": likes, "views": views, "commentCount": commentCount, "ownerUid": ownerUid] as [String : Any]
//        let firstPost = Post(user: user, dictionary: postDict)
//
//
//
//        let secondPostId = "2"
//        let secondPostImageUrl = "https://firebasestorage.googleapis.com/v0/b/digmeproject.appspot.com/o/post_images%2F2B24D913-1315-4526-A358-5FFDA19AD3E2?alt=media&token=6fff28bc-f52e-48a6-9bf7-fc030f551341"
//
//
//        let secondVideoUrl: String? = "https://firebasestorage.googleapis.com/v0/b/digmeproject.appspot.com/o/post_videos%2FFE9D9C9D-9FC2-4ADD-B44C-A1057C2E53E6.mov?alt=media&token=7b797192-e694-4a26-867c-067b7957920f"
//
//        let secondcaption: String? = "Tomorrow is my birthday yooo"
//
//
//        let secondlikes: Int = 20
//        let secondviews: Int = 15
//        let secondcommentCount: Int = 124
//        let secondownerUid: String = CURRENT_UID ?? ""
//
//
//        let secondpostDict = ["postId": secondPostId, "postImageUrl": secondPostImageUrl, "videoUrl": secondVideoUrl, "caption": secondcaption, "creationDate": creationDate, "likes": secondlikes, "views": secondviews, "commentCount": secondcommentCount, "ownerUid": secondownerUid] as [String : Any]
//
//        let secondPost = Post(user: user, dictionary: secondpostDict)
//
//        return [firstPost, secondPost]
//    }
//
}
