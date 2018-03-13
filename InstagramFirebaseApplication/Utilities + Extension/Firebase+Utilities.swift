//
//  Firebase+Utilities.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/12/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid:String , completion : @escaping(User)->()){
        
        let refUser = Database.database().reference().child("users").child(uid)
        refUser.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String : Any] else {return}
            let user = User(dictionary: userDictionary, uid: uid)
            completion(user)
        }) { (error) in
            print("Failed to fetch user for post", error)
        }
        
    }
}
