//
//  ProfileHeader.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/16/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Kingfisher
class ProfileHeader: UICollectionViewCell {
    
    //MARK: - Init
    fileprivate func ovalViewSetUpView() {
        
        
        let ovalView = OvalView()
        addSubview(ovalView)
        ovalView.backgroundColor = .clear
        ovalView.centerInSuperview(size: .init(width: 300, height: 240))//.init(width: 150, height: 90))
        
        let triangleView = TrianglePointingView()
        insertSubview(triangleView, belowSubview: ovalView)
        triangleView.fillColor = .red
        triangleView.anchor(top: ovalView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: -43, left: 0, bottom: 0, right: 0), size: .init(width: 43, height: 120)) //w30, 60 h
        triangleView.centerXAnchor.constraint(equalTo: ovalView.centerXAnchor, constant: -45).isActive = true //-20
        triangleView.flipY()
        triangleView.transform = triangleView.transform.rotated(by: .pi / 2)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        handleSetUpSetAttributedTexts()
    }
    
    
    
    
    //MARK: - Properties
    let mainFontSize: CGFloat = 16.0
    
    var user: TikTokUser! {
        didSet {
            usernameLabel.text = user.username
            guard let url = URL(string: user.profileImageUrl) else {return}
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: url)
            
        }
    }
    
    fileprivate lazy var profileFilterView: ProfileFilterView = {
        let view = ProfileFilterView()
        view.delegate = self
        return view
    }()
    

    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightRed
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100 / 2
        return imageView
    }()
    
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@samisays11"
        label.font = defaultFont(size: 15.5)
        label.textAlignment = .center
        return label
    }()
    
    
    fileprivate let followingCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let followersCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    
    fileprivate let likesCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    
    fileprivate let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = baseWhiteColor.cgColor//UIColor.lightGray.cgColor
        button.layer.cornerRadius = 2
        return button
    }()
    
    
    fileprivate let instagramButton: UIButton = {
       let button = UIButton(type: .system)
       let image = UIImage(named: "instagramIcon")?.withRenderingMode(.alwaysTemplate)
       button.setImage(image, for: .normal)
       button.layer.borderWidth = 1
       button.layer.borderColor = baseWhiteColor.cgColor//UIColor.lightGray.cgColor
       button.tintColor = .black
        button.layer.cornerRadius = 2

       return button
   }()
    
    
    fileprivate let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = baseWhiteColor.cgColor//UIColor.lightGray.cgColor
        button.tintColor = .black
        button.layer.cornerRadius = 2
        return button
    }()
    
    
    let horizontalMenuBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let invisibleUnderLineMenuBarView: UIView = {
        let view = UIView()
        return view
    }()
       
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        
        
        profileImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        profileImageView.centerXInSuperview()
        
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 8, bottom: 0, right: 8))
        
        let stackView = UIStackView(arrangedSubviews: [followingCountLabel, followersCountLabel, likesCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        addSubview(stackView)
        let padding = frame.width * 0.10
        stackView.anchor(top: usernameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 60))
        
        
        
        let firstVerticalLine = handleCreateLineSeperatorView()
        let secondVerticalLine = handleCreateLineSeperatorView()

        addSubview(firstVerticalLine)
        addSubview(secondVerticalLine)


        firstVerticalLine.anchor(top: nil, leading: followersCountLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: -5, bottom: 0, right: 0),  size: .init(width: 1, height: 15))
        firstVerticalLine.centerYAnchor.constraint(equalTo: followersCountLabel.centerYAnchor).isActive = true

        
        
        secondVerticalLine.anchor(top: nil, leading: followersCountLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 1, height: 15))
        secondVerticalLine.centerYAnchor.constraint(equalTo: followersCountLabel.centerYAnchor).isActive = true

        let dimen: CGFloat = 42.5
        addSubview(editButton)
        
        editButton.anchor(top: stackView.bottomAnchor, leading: followingCountLabel.leadingAnchor, bottom: nil, trailing: secondVerticalLine.trailingAnchor, padding: .init(top: 5, left: 40, bottom: 0, right: -4), size: .init(width: 0, height: dimen))

        
//        editButton.anchor(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: followersCountLabel.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 45))
        
        
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: editButton.topAnchor, leading: editButton.trailingAnchor, bottom: editButton.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: dimen, height: 0))
        //
        
//        addSubview(instagramButton)
//        instagramButton.anchor(top: editButton.topAnchor, leading: editButton.trailingAnchor, bottom: editButton.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 45, height: 0))
//
//
//        addSubview(bookmarkButton)
//
//        bookmarkButton.anchor(top: editButton.topAnchor, leading: instagramButton.trailingAnchor, bottom: editButton.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 45, height: 0))
        
        
        
        
        let firstHorizontalLine = handleCreateLineSeperatorView()
        let secondHorizontalLine = handleCreateLineSeperatorView()

       addSubview(firstHorizontalLine)
       addSubview(secondHorizontalLine)

        
        firstHorizontalLine.anchor(top: editButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 28, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        

        secondHorizontalLine.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: -1, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        
        addSubview(profileFilterView)
        
        profileFilterView.anchor(top: firstHorizontalLine.topAnchor, leading: leadingAnchor, bottom: secondHorizontalLine.topAnchor, trailing: trailingAnchor, padding: .init(top: 0.5, left: 0, bottom: 0.8, right: 0))
        
        
        
        addSubview(invisibleUnderLineMenuBarView)
        let count: CGFloat = CGFloat(ProfileFilterOptions.allCases.count)
        invisibleUnderLineMenuBarView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 2, right: 0), size: .init(width: frame.width / count, height: 2))

        
        invisibleUnderLineMenuBarView.addSubview(horizontalMenuBarView)
        horizontalMenuBarView.centerInSuperview(size: .init(width: 50, height: 2))

    }
    
    
    
    
    
    
    fileprivate func handleSetUpSetAttributedTexts() {
        followingCountLabel.attributedText = setupAttributedTextWithFonts(titleString: "2 \n", subTitleString: "Following", attributedTextColor: .lightGray, mainColor: .black, mainfont: UIFont.boldSystemFont(ofSize: mainFontSize), subFont: UIFont.systemFont(ofSize: 12.5))
        
        followersCountLabel.attributedText = setupAttributedTextWithFonts(titleString: "1 \n", subTitleString: "Followers", attributedTextColor: .lightGray, mainColor: .black, mainfont: UIFont.boldSystemFont(ofSize: mainFontSize), subFont: UIFont.systemFont(ofSize: 12.5))
        
        likesCountLabel.attributedText = setupAttributedTextWithFonts(titleString: "0 \n", subTitleString: "Likes", attributedTextColor: .lightGray, mainColor: .black, mainfont: UIFont.boldSystemFont(ofSize: mainFontSize), subFont: UIFont.systemFont(ofSize: 12.5))

               
    }
    
    
    func handleCreateLineSeperatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = baseWhiteColor//UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {return}
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.invisibleUnderLineMenuBarView.frame.origin.x = xPosition
        }
    }
}


class OvalView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        var ovalPath = UIBezierPath(ovalIn: bounds)
        UIColor.red.setFill()
        ovalPath.fill()
        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = ovalPath.cgPath
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.blue.cgColor
//        shapeLayer.lineWidth = 5.0
//        self.layer.addSublayer(shapeLayer)
     
    }
}



class TrianglePointingView: UIView {
    
    var path: UIBezierPath!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    
    var fillColor: UIColor = UIColor.white
    var strokeColor: UIColor = UIColor.white
    var borderWidthColor: CGColor = UIColor.clear.cgColor
    
    
    override func draw(_ rect: CGRect) {
        self.createTriangle()
        
        // Specify the fill color and apply it to the path.
        fillColor.setFill()
        path.fill()
        
        // Specify a border (stroke) color.
        strokeColor.setStroke()
        path.stroke()
    }
    
    
    
    
    func createTriangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height)) //left line
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height)) //right line
        path.close()
        
        // Add border width to the triangle, only visible in Hashtag header
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath//maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderWidthColor//baseWhiteColor.cgColor
        borderLayer.lineWidth = 0.5
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
