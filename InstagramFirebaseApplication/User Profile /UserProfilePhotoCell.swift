//
//  UserProfilePhotoCell.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/10/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post : Post? {
        didSet {
            
            guard let imageUrl = post?.imageUrl else {return}
            guard let url = URL(string: imageUrl) else {return}
             let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("failed to fetch image : ", error)
                    
                }
                guard let imageData = data else {return}
                DispatchQueue.main.async {
                    self.photoImageView.image = UIImage(data: imageData)
                }
                
            }.resume()
        }
    }
    
    let photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .brown
        setupViewComponent()
    }
    
    fileprivate func setupViewComponent() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
