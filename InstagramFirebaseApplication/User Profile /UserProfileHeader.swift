//
//  UserProfileHeader.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/3/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserProfileHeader: UICollectionViewCell {
    
    var user : UserModel? {
        didSet{
//            print("did set \(user?.username)")
            setupProfileImage()
            userNameLabel.text = user?.username
        }
    }
    
    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    let gridButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        return button
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return button
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .clear
        return label
    }()
    
    let postLabel : UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributtedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributtedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributtedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributtedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributtedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributtedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupProfileViewConstraints()
        setupBottomToolBar()
        setupUserStatViews()
        setupForEditProfileButton()
        
    }
    
    fileprivate func setupBottomToolBar() {
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        let topSeparatorView = UIView()
        topSeparatorView.backgroundColor = UIColor.lightGray
        addSubview(topSeparatorView)
        topSeparatorView.anchor(top: nil, left: leftAnchor, bottom: stackView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = UIColor.lightGray
        addSubview(bottomSeparatorView)
        bottomSeparatorView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    fileprivate func setupProfileViewConstraints(){
        addSubview(profileImageView)
        addSubview(userNameLabel)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        userNameLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: -12, width: 0, height: 40)
        
    }
    
    fileprivate func setupUserStatViews() {
    
      let userStatStackView = UIStackView(arrangedSubviews: [postLabel,followersLabel, followingLabel])
        userStatStackView.distribution = .fillEqually
        userStatStackView.axis = .horizontal
        addSubview(userStatStackView)
        userStatStackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 50)
        
    }
    fileprivate func setupForEditProfileButton() {
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 20, paddingBottom: 0, paddingRight: -10, width: 0, height: 34)
    }
    
    fileprivate func setupProfileImage() {

        guard let profileImageUrl = user?.profileImageURL else {return}
        guard let url = URL(string: profileImageUrl) else {return}
//         Using SDWeb Image Pod
         self.profileImageView.sd_setImage(with: url, completed: nil)
        
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if let err = error {
//                print("Failed to fetch profile image : ", err)
//            }
//            // check for http response status of 200 (HTTP ok)
//            guard let data = data else{return}
//
//            // need to load image in view main thread
//            DispatchQueue.main.async {
//                self.profileImageView.image = UIImage(data: data)
//            }
//        }).resume()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
