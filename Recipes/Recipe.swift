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
    
    private var _title = ""
    private var _cookTime = Int()
    private var _image = UIImage(named: "recipeImage")
    
    init(title: String, cookTime: Int, image: UIImage) {
        self._title = title
        self._cookTime = cookTime
        self._image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let titleObject = aDecoder.decodeObject(forKey: Keys.Title) as? String {
            _title = titleObject
        }
        
        let cookTimeObject = aDecoder.decodeInteger(forKey: Keys.CookTime)
        _cookTime = cookTimeObject
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_title, forKey: Keys.Title)
        aCoder.encode(_cookTime, forKey: Keys.CookTime)
    }
    
    var Title: String {
        get {
            return _title
        } set {
            _title = newValue
        }
    }
    
    var CookTime: Int {
        get {
            return _cookTime
        } set {
            _cookTime = newValue
        }
    }
    
    var Image: UIImage {
        get {
            return _image!
        } set {
            _image = newValue
        }
    }
}
