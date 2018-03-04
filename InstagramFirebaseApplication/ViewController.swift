//
//  ViewController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 1/8/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoVeiw : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoImport), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    lazy var signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    @objc private func handlePhotoImport(){
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    // MARK: Image Picker delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editidImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            
            plusPhotoVeiw.setImage(editidImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
            
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            plusPhotoVeiw.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoVeiw.layer.cornerRadius = plusPhotoVeiw.frame.width / 2
        plusPhotoVeiw.layer.masksToBounds = true
        plusPhotoVeiw.layer.borderWidth = 3
        plusPhotoVeiw.layer.borderColor = UIColor.black.cgColor
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc private func handleTextInputChange(){
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    
    
    @objc private func handleSignUp() {
        
        guard let email = emailTextField.text, email.count > 0  else {
            return
        }
        guard let username = usernameTextField.text, username.count > 0 else {
            return
        }
        guard let password = passwordTextField.text, password.count > 0  else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user , error : Error?) in
            if let err = error {
                print("failed to create user", err)
                return
            }
            print("successfully Created user", user?.uid ?? "")
            
            guard let image = self.plusPhotoVeiw.imageView?.image else {return}
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.2) else {return}
            
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("profileImages").child(fileName).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload image on storage", err)
                }
                
                guard let profileImageURL = metadata?.downloadURL()?.absoluteString else {return}
                
                print("sucessufully uploaded data ", profileImageURL)
                
                guard let uid = user?.uid else {return}
                let userDictionaryValues = ["username":username, "profileImageURL" : profileImageURL]
                let values = [uid: userDictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save user info on database",err)
                    }
                    print("successfully saved user infor on database")
                })
                
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputField()
    }
    
    
    fileprivate func setupInputField(){
        
        view.addSubview(plusPhotoVeiw)
        plusPhotoVeiw.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoVeiw.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Stack View
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoVeiw.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: 0, height: 200)
    }
}

extension UIView {
    
    func anchor(top : NSLayoutYAxisAnchor? , left : NSLayoutXAxisAnchor?, bottom : NSLayoutYAxisAnchor?, right : NSLayoutXAxisAnchor? ,paddingTop : CGFloat, paddingLeft : CGFloat, paddingBottom : CGFloat, paddingRight : CGFloat, width : CGFloat, height : CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom  {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
}

