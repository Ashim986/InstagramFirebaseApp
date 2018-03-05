//
//  MainTabBarController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/1/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super .viewDidLoad()
        
        if Auth.auth().currentUser == nil{
            // wait for tab bar to load properly and execute this code
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}
