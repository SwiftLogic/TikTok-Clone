//
//  HomeFeedController.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVKit
import Lottie
import Firebase
let paddingForTabbar: CGFloat = 30//29.5
class HomeFeedController: UIViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        navigationController?.navigationBar.isHidden = true
        setUpViews()
        handleFetchCurrentUser()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPlaying == true {
            player.play()
            if let cell = currentVerticalCell {
                cell.rotateView(view: cell.discJockeyView)
            }
        }
    }
    
    
//    override var prefersStatusBarHidden: Bool {
//      return true
//    }
    
    
    //MARK: - Properties
    fileprivate var isPlaying = false
    var timeObserverToken: Any?
    weak var currentVerticalCell: VerticalFeedCell?

    
    var currentUser: User? {
        didSet {
            handleFetchPost()
        }
    }
   
//   fileprivate let urlString = "https://firebasestorage.googleapis.com/v0/b/lens-e2a52.appspot.com/o/lens_videos%2F2A84A207-2BFB-45AB-BC78-1D253AA49364.mov?alt=media&token=8c228898-3b6f-4f14-8e91-f444a68ab802"
    
    
    //"https://firebasestorage.googleapis.com/v0/b/lens-e2a52.appspot.com/o/lens_videos%2F5AA53A16-FD53-49D5-AAD8-62179AE571DD.mov?alt=media&token=6fe264f8-b557-49a7-8498-df17ff52bb44"
    
    //"https://firebasestorage.googleapis.com/v0/b/digmeproject.appspot.com/o/post_videos%2F6FB30940-05A6-40DC-8264-5241A0739259.mov?alt=media&token=042aff2f-992e-4391-b3b6-45999aa9bf20"
    
    // "https://firebasestorage.googleapis.com/v0/b/digmeproject.appspot.com/o/post_videos%2F0666A3C1-CA8A-465F-A11D-ABB23884331F.mov?alt=media&token=56923b7d-e028-41d6-ac5e-42e4fd0ca275"
    
    
    fileprivate var posts: [Post] = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }

    
    let FOLLOWING_CELL_ID = "FOLLOWINGCELLID"
    let FORYOU_CELL_ID = "FORYOUCELLID"

     lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    lazy var tikTokMenuBar: TikTokMenuBar = {
        let tikTokMenuBar = TikTokMenuBar()
        tikTokMenuBar.homeFeedController = self
        return tikTokMenuBar
    }()
    
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    
    
    lazy var loadingAnimation: AnimationView = {
        let animationView = AnimationView(name: "TikTokLoadingAnimation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animationSpeed = 1//0.8
        animationView.loopMode = .loop
        return animationView
    }()
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.addSubview(collectionView)
        collectionView.fillSuperview(padding: .init(top: 0, left: 0, bottom: -paddingForTabbar, right: 0))
        collectionView.register(BaseHomeFeedCell.self, forCellWithReuseIdentifier: FOLLOWING_CELL_ID)
        collectionView.register(BaseHomeFeedCell.self, forCellWithReuseIdentifier: FORYOU_CELL_ID)

        view.addSubview(tikTokMenuBar)
        tikTokMenuBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 35)) //top: 25
        
        view.addSubview(loadingAnimation)
        loadingAnimation.centerInSuperview(size: .init(width: 50, height: 50))
        loadingAnimation.play()
    }
    
    
    
    fileprivate func handlePlayAnimation(show: Bool) {
        if show {
            loadingAnimation.isHidden = false
            loadingAnimation.play()

        } else {
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if loadingAnimation.isHidden == true {
                return
            }
                loadingAnimation.pause()
                loadingAnimation.isHidden = true
//            }
        }
    }
    
    func handleFetchCurrentUser() {
       guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let user = User(uid: snapshot.key, dictionary: dict)
            self.currentUser = user
        }
   }
    
    
    @objc private func handleFetchPost() {
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            dict.forEach { (key, value) in
                let user = self.currentUser!
                guard let postDict = value as? [String : Any] else {return}
                let post = Post(user: user, dictionary: postDict)
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }) { (error) in
            print("failed to fetch posts:", error.localizedDescription)
        }
    }
    
    
    
    
    fileprivate func removePeriodicTimeObserver() {
        isPlaying = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
            player.replaceCurrentItem(with: nil)
            playerLayer.removeFromSuperlayer()
            print("stopped firing period observer")
        }
    }
    
        
        ///grabs video url from our caching manager
     fileprivate func handleFetchVideoFromCachingManagerUsing(urlString: String, completion: @escaping (URL?) -> ()) {
           CacheManager.shared.getFileWith(stringUrl: urlString) { result in
               
               switch result {
               case .success(let url):
                   // do some magic with path to saved video
                   completion(url)
                   break;
               case .failure(let error):
                   // handle errror
                   completion(nil)
                   print(error, "failed to find value of key\(urlString) in cache and also synchroniously failed to fetch video from our remote server, most likely a network issue like lack of connectivity or database failure")
                   break;
               }
           }
       }
        
        
      fileprivate  func initializeVideoPlayer(url: URL, cell: VerticalFeedCell) {
            removePeriodicTimeObserver()
            guard let maintabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            maintabbarController.progressView.setProgress(0, animated: false)
            player.replaceCurrentItem(with: nil) //this right here removes all previes players before initializing
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = cell.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            self.player = player
            self.playerLayer = playerLayer
            cell.postImageView.layer.addSublayer(playerLayer) // we added it to imageview layer so we will be able to pinch to zoom videos as well
            cell.handleResetCellUI()
            player.play()
            isPlaying = true
            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 0.001, preferredTimescale: timeScale) //fires every 0.001 seconds
        
            timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
                guard let self = self else {return}
                guard let currentItemDuration = self.player.currentItem?.duration else {return}
                let durationInSeconds = CMTimeGetSeconds(currentItemDuration)
                guard durationInSeconds.isFinite else {return} //prevents crashes
                if progressTime != currentItemDuration {
                    maintabbarController.progressView.setProgress(Float(CMTimeGetSeconds(progressTime)) / Float(durationInSeconds), animated: true)
                    
                    self.handlePlayAnimation(show: false)



                } else {
                    maintabbarController.progressView.setProgress(0, animated: false)
                }
            })
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEndTime),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
        
    
    @objc fileprivate func playerDidPlayToEndTime(notification: Notification) {
          player.seek(to: CMTime.zero)
          player.play()
       }
    
}





//MARK: - CollectionView Delegates
extension HomeFeedController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FOLLOWING_CELL_ID, for: indexPath) as! BaseHomeFeedCell
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            cell.posts = posts
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FORYOU_CELL_ID, for: indexPath) as! BaseHomeFeedCell
            cell.backgroundColor = .clear
            cell.delegate = self
            cell.posts = posts
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
     func scrollToMenuIndex(menuIndex: Int) {
        //this is a bug for ios 13
            collectionView.isPagingEnabled = false
            let indexPath = IndexPath(item: menuIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
        
        
        
        
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            
            let index = targetContentOffset.pointee.x / view.frame.width
            
            let indexPath = IndexPath(item: Int(index), section: 0)
            
            
            tikTokMenuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            tikTokMenuBar.handleScrollSlideBar(indexPath: indexPath)
            
            

        }
    
 }





//MARK: - BaseHomeFeedCellDelegate
extension HomeFeedController: BaseHomeFeedCellDelegate {
    
    
   
    
    
    func handleSetUpVideoPlayer(cell: VerticalFeedCell, videoUrlString: String) {
        handlePlayAnimation(show: true)
        //to cancel out currently playing player
        currentVerticalCell = cell
        handleFetchVideoFromCachingManagerUsing(urlString: videoUrlString) {[weak self] (url) in
            guard let self = self, let urlUnwrapped = url else {return}
            self.initializeVideoPlayer(url: urlUnwrapped, cell: cell)
        }
    }
    
    func didTapPlayButton(play: Bool) {
        if play == true && isPlaying == false {
            player.play()
            isPlaying = true
        } else if play == false && isPlaying == true {
            player.pause()
            isPlaying = false
        }
    }
    
}
