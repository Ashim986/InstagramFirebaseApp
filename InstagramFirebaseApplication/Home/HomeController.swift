//
//  HomeController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/12/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Firebase



class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        setupNavgationItem()
        fetchPosts()
    }
    
    fileprivate func fetchPosts(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            dictionary.forEach({ (key,value) in
                
                guard let dictionary = value as? [String: Any] else {return}
                let post = Post( user: user, dictionary: dictionary)
                self.posts.append(post)
                self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("Failed to fetch posts",err)
        }
    }
    
    fileprivate func setupNavgationItem() {
       navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 40  + 8 + 8 // profile image view height, top and bottom padding for image
        height += view.frame.width // height for image view
        height += 50 // actionButton Height
        height += 60 // for image caption
        return CGSize(width: view.frame.width, height: height)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        
        return cell
    }
}
