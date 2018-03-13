//
//  Post.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/10/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl : String
    let user : User
    let caption : String
    init(user : User ,dictionary : [String : Any]){
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
    
}


