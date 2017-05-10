//
//  extensions.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/11/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import UIKit
import Foundation


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
