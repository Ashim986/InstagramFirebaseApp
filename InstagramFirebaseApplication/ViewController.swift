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
//        button.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        button.backgroundColor = .yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
       return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoVeiw)
        view.addSubview(emailTextField)
        
        viewConstraint()
        
    }
    private func viewConstraint(){
      
        NSLayoutConstraint.activate([plusPhotoVeiw.topAnchor.constraint(equalTo: view.topAnchor, constant: 40), plusPhotoVeiw.centerXAnchor.constraint(equalTo: view.centerXAnchor),plusPhotoVeiw.widthAnchor.constraint(equalToConstant: 140), plusPhotoVeiw.heightAnchor.constraint(equalToConstant: 140)])
        NSLayoutConstraint.activate([emailTextField.topAnchor.constraint(equalTo: plusPhotoVeiw.bottomAnchor, constant: 10), emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40), emailTextField.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -40), emailTextField.heightAnchor.constraint(equalToConstant: 50)])
    }

      
}

