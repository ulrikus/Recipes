//
//  Recipe.swift
//  Recipes
//
//  Created by Utheim Sverdrup, Ulrik on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

class Recipe: NSObject, NSCoding {
    
    struct Keys {
        static let Title = "recipe"
        static let CookTime = "cookTime"
        static let Image = "image"
    }
    
    let title: String
    let cookTime: Int
    let image: UIImage?
    
    init(title: String, cookTime: Int, image: UIImage) {
        self.title = title
        self.cookTime = cookTime
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let titleObject = aDecoder.decodeObject(forKey: Keys.Title) as? String {
            title = titleObject
        } else {
            title = "No title"
        }
        
        let cookTimeObject = aDecoder.decodeInteger(forKey: Keys.CookTime)
        cookTime = cookTimeObject
        
        if let imageData = aDecoder.decodeObject(forKey: Keys.Image) as? Data {
            image = UIImage(data: imageData)
        } else {
            image = #imageLiteral(resourceName: "standardRecipeImage")
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Keys.Title)
        aCoder.encode(cookTime, forKey: Keys.CookTime)
        aCoder.encode(image, forKey: Keys.Image)
    }
}
