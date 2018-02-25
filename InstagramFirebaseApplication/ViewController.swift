//
//  ViewController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 1/8/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let plusPhotoVeiw : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
       return textField
    }()
    
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputField()
    }
    
    
    fileprivate func setupInputField(){
        
        view.addSubview(plusPhotoVeiw)
        NSLayoutConstraint.activate([plusPhotoVeiw.topAnchor.constraint(equalTo: view.topAnchor, constant: 40), plusPhotoVeiw.centerXAnchor.constraint(equalTo: view.centerXAnchor),plusPhotoVeiw.widthAnchor.constraint(equalToConstant: 140), plusPhotoVeiw.heightAnchor.constraint(equalToConstant: 140)])
        
        // Stack View
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: plusPhotoVeiw.bottomAnchor, constant: 20), stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40), stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40), stackView.heightAnchor.constraint(equalToConstant: 200)])
     
    }

      
}

