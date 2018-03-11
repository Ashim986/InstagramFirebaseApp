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
    
    init(dictionary : [String : Any]){
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
    
}
