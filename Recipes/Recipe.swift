//
//  Recipe.swift
//  Recipes
//
//  Created by Utheim Sverdrup, Ulrik on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import Foundation

class Recipe: NSObject, NSCoding {
    
    struct Keys {
        static let Title = "recipe"
        static let CookTime = "cookTime"
    }
    
    private var _title = ""
    private var _cookTime = 0
    
    init(title: String, cookTime: Int) {
        self._title = title
        self._cookTime = cookTime
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let titleObject = aDecoder.decodeObject(forKey: Keys.Title) as? String {
            _title = titleObject
        }
        if let cookTimeObject = aDecoder.decodeObject(forKey: Keys.CookTime) as? Int {
            _cookTime = cookTimeObject
        }
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
}
