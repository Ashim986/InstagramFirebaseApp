//
//  UserProfileController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/1/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user : UserModel?
    
    let headerID = "headerID"
    let cellID = "cellID"
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(UserProfilePhotoCell.self , forCellWithReuseIdentifier: cellID)
        fetchUser()
        setupLogOutButton()
        fetchPosts()
    }
    
    fileprivate func fetchPosts() {
        // fetching user from their login detail require observe the event at the perticular node, with snapshot
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let refrence = Database.database().reference().child("posts").child(uid)
        
        
        refrence.observe(.value, with: { (snapshot) in
            print(snapshot.value)
            
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            
            dictionaries.forEach({ (key, value) in
                print("Key : \(key) , Value : \(value)")
                guard let dictionary = value as? [String : Any] else {return}
                
                let imageUrl = dictionary["imageUrl"] as? String
                print("imageUrl : ",imageUrl as Any)
                
                let post = Post(dictionary: dictionary)
               
                self.posts.append(post)
            })
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("failed to fetch posts : ", err)
        }
        
    }
    
    fileprivate func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
                
            }catch let signOutError {
                print("Failed to sign out user", signOutError)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width  / 3 - 1
        return CGSize(width: width, height: width )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePhotoCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return }
            
            self.user = UserModel(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("failed to fetch user ", err)
        }
    }
    
    // MARK: Header section
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}


struct UserModel {
    let username : String
    let profileImageUrl : String
    
    init(dictionary : [String : Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}




