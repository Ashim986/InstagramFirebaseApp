//
//  CustomImageView.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/11/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

var imageCashe = [String : UIImage]()

class CustomImageView : UIImageView {
    
    var lastUrlUsedToLoadImage : String?
    
    func loadImage (urlString : String)  {
        lastUrlUsedToLoadImage = urlString
        guard let url = URL(string: urlString) else {return}
        if let cashedImage = imageCashe[urlString] {
            self.image = cashedImage
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("failed to fetch image : ", err)
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            guard let imageData = data else {return}
            let photoImage = UIImage(data: imageData)
            imageCashe[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
    
}
