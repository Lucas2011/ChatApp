//
//  Extensions.swift
//  Chatdemo
//
//  Created by Lucas on 9/12/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadingImgUsingCatchWithUrlString(url:String){
        
        
        //profile img 
        self.image = nil
        //check the cache
        if let cacheImage = imageCache.object(forKey: url as NSString){
            self.image = cacheImage
            return
        }
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            DispatchQueue.main.async {
                if data == nil {return}
                if let downloadImageCache = UIImage(data: data!){
                    imageCache.setObject(downloadImageCache, forKey: url as NSString)
                    self.image = UIImage(data: data!)

                }
            }
            
            }.resume()
    }
    
    
}
