//
//  User.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/12/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation

struct User{
    let username : String
    let profileImageUrl : String
    let uid : String
    
    init(dictionary : [String : Any], uid : String) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}
