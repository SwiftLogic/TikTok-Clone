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
protocol ProfileHeaderDelegate: AnyObject {
    func didTapEditProfile()
    func didTapBookmark()
}
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
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: ProfileHeaderDelegate?
    
    let mainFontSize: CGFloat = 17
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            usernameLabel.text = "@\(user.username)"
            if let url = URL(string: user.profileImageUrl) {
                profileImageView.kf.indicatorType = .activity
                profileImageView.kf.setImage(with: url)
            }
            handleSetUpSetAttributedTexts(followingCount: user.followingCount, followersCount: user.followersCount, postCount: user.postCount)
            
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
        label.text = "_"
        label.font = defaultFont(size: 15.5)
        label.textAlignment = .center
        return label
    }()
    
    
    fileprivate let followingCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "_"

        return label
    }()
    
    fileprivate let followersCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "_"

        return label
    }()
    
    
    
    fileprivate let likesCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "_"

        return label
    }()
    
    
    
    fileprivate lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.titleLabel?.font = avenirBoldFont(size: 15.5)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = lineSeperatorColor.cgColor
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleDidTapEditProfile), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let instagramButton: UIButton = {
       let button = UIButton(type: .system)
       let image = UIImage(named: "instagramIcon")?.withRenderingMode(.alwaysTemplate)
       button.setImage(image, for: .normal)
       button.layer.borderWidth = 1
        button.layer.borderColor = lineSeperatorColor.cgColor
       button.tintColor = .black
        button.layer.cornerRadius = 2
       return button
   }()
    
    
    fileprivate lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = lineSeperatorColor.cgColor
        button.tintColor = .black
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(didTapBookmarButton), for: .touchUpInside)
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
    
    
    fileprivate let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add bio"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
       
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        
        
        profileImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        profileImageView.centerXInSuperview()
        
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 15, left: 8, bottom: 0, right: 8))
        
        let stackView = UIStackView(arrangedSubviews: [followingCountLabel, followersCountLabel, likesCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        addSubview(stackView)
        let padding = frame.width * 0.13
        stackView.anchor(top: usernameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 60))
        
        
        
        let firstVerticalLine = handleCreateLineSeperatorView()
        let secondVerticalLine = handleCreateLineSeperatorView()

        addSubview(firstVerticalLine)
        addSubview(secondVerticalLine)
        addSubview(editButton)
        addSubview(bookmarkButton)
        


        firstVerticalLine.anchor(top: nil, leading: followersCountLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: -5, bottom: 0, right: 0),  size: .init(width: 1, height: 20))
        firstVerticalLine.centerYAnchor.constraint(equalTo: followersCountLabel.centerYAnchor, constant: 2).isActive = true

        
        
        secondVerticalLine.anchor(top: nil, leading: followersCountLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 1, height: 20))
        secondVerticalLine.centerYAnchor.constraint(equalTo: followersCountLabel.centerYAnchor, constant: 2).isActive = true

        let dimen: CGFloat = 42.5
        
        editButton.anchor(top: stackView.bottomAnchor, leading: followingCountLabel.leadingAnchor, bottom: nil, trailing: bookmarkButton.leadingAnchor, padding: .init(top: 5, left: 30, bottom: 0, right: 3.5), size: .init(width: 0, height: dimen))
//        likesCountLabel.backgroundColor = .red
        
//        editButton.anchor(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: followersCountLabel.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 45))
        
        bookmarkButton.anchor(top: editButton.topAnchor, leading: nil, bottom: editButton.bottomAnchor, trailing: likesCountLabel.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 30), size: .init(width: dimen, height: 0))
        
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

        
        firstHorizontalLine.anchor(top: editButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 38, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        

        secondHorizontalLine.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: -1, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        
        addSubview(profileFilterView)
        
        profileFilterView.anchor(top: firstHorizontalLine.topAnchor, leading: leadingAnchor, bottom: secondHorizontalLine.topAnchor, trailing: trailingAnchor, padding: .init(top: 0.5, left: 0, bottom: 0.8, right: 0))
        
        
        
        addSubview(invisibleUnderLineMenuBarView)
        let count: CGFloat = CGFloat(ProfileFilterOptions.allCases.count)
        invisibleUnderLineMenuBarView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 2, right: 0), size: .init(width: frame.width / count, height: 2))

        
        invisibleUnderLineMenuBarView.addSubview(horizontalMenuBarView)
        horizontalMenuBarView.centerInSuperview(size: .init(width: 50, height: 2))
        
        
        addSubview(bioLabel)
        bioLabel.anchor(top: editButton.bottomAnchor, leading: followingCountLabel.leadingAnchor, bottom: firstHorizontalLine.topAnchor, trailing: likesCountLabel.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))

    }
    
    
    
    
    
    
    fileprivate func handleSetUpSetAttributedTexts(followingCount: Int, followersCount: Int, postCount: Int) {
        let subFont = UIFont(name: Fonts.acherusGrotesque, size: 12.5)!
        let mainFont = avenirBoldFont(size: mainFontSize)//UIFont.boldSystemFont(ofSize: mainFontSize)
        
        followingCountLabel.attributedText = setupAttributedTextWithFonts(titleString: "\(followingCount) \n", subTitleString: "Following", attributedTextColor: .lightGray, mainColor: .black, mainfont: mainFont, subFont: subFont) //UIFont.systemFont(ofSize: 12.5)
        
        
        followersCountLabel.attributedText = setupAttributedTextWithFonts(titleString: "\(followersCount) \n", subTitleString: "Followers", attributedTextColor: .lightGray, mainColor: .black, mainfont: mainFont, subFont: subFont)
        
        likesCountLabel.attributedText = setupAttributedTextWithFonts(titleString: "\(postCount) \n", subTitleString: "Likes", attributedTextColor: .lightGray, mainColor: .black, mainfont: mainFont, subFont: subFont)
    }
    
    
    func handleCreateLineSeperatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = baseWhiteColor//UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }
    
    
    //MARK: - Target Selector
    @objc fileprivate func handleDidTapEditProfile() {
        delegate?.didTapEditProfile()
    }
    
    
    @objc fileprivate func didTapBookmarButton() {
        delegate?.didTapBookmark()
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
