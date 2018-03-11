//
//  SharePhotoController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/10/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage : UIImage? {
        didSet {
            self.sharingImageView.image = selectedImage
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    let containerView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let sharingImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let sharingTextView : UITextView = {
       let textView = UITextView()
        textView.text = "lets Begin sharing some post "
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextView()
    }
    
    @objc private func handleShare() {
        let filename = NSUUID().uuidString
        guard let caption = sharingTextView.text , caption.count > 0  else {return}
        guard let image = selectedImage else {return}
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print("failed to upload post image :", error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
            self.saveToDatabaseWithImageUrl(imageURL: imageURL, caption: caption)
        }
        
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageURL : String, caption : String) {
        guard  let postImage = selectedImage  else {
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let childPostRefrence =  Database.database().reference().child("posts").child(uid)
        
        let reference =  childPostRefrence.childByAutoId()
        
        let values : [String : Any] = ["imageUrl" : imageURL , "caption" : caption , "imageWidth" : postImage.size.width, "imageHeight" : postImage.size.height , "creationDate" : Date().timeIntervalSince1970]
        
        reference.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("failed to upadate child values",err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func setupImageAndTextView() {
        view.addSubview(containerView)
        
        // use topLayoutGuide.bottomAnchor for < iOS 11
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        view.addSubview(sharingImageView)
        
        sharingImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 84, height: 0)
        
        view.addSubview(sharingTextView)
        sharingTextView.anchor(top: sharingImageView.topAnchor, left: sharingImageView.rightAnchor, bottom: sharingImageView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: -6, width: 0, height: 0)
    }
}
