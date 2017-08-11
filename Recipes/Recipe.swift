//
//  Recipe.swift
//  Recipes
//
//  Created by Utheim Sverdrup, Ulrik on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

class Recipe: NSObject, NSCoding {
    
    enum Keys: String {
        case title
        case cookingTime
        case imageURL
    }
    
    let title: String
    let cookingTime: Int
    let imageURL: String?
    
    init(title: String, cookTime: Int, imageURL: String) {
        self.title = title
        self.cookingTime = cookTime
        self.imageURL = imageURL
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let titleObject = aDecoder.decodeObject(forKey: Keys.title.rawValue) as? String {
            title = titleObject
        } else {
            title = "No title"
        }
        
        let cookTimeObject = aDecoder.decodeInteger(forKey: Keys.cookingTime.rawValue)
        cookingTime = cookTimeObject
        
        if let imageUrlObject = aDecoder.decodeObject(forKey: Keys.imageURL.rawValue) as? String {
            imageURL = imageUrlObject
        } else {
            imageURL = nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Keys.title.rawValue)
        aCoder.encode(cookingTime, forKey: Keys.cookingTime.rawValue)
        aCoder.encode(imageURL, forKey: Keys.imageURL.rawValue)
    }
}
