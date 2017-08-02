//
//  DetailViewController.swift
//  Recipes
//
//  Created by Utheim Sverdrup, Ulrik on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var recipeTitle: String?
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTitleLabel.text = recipeTitle
    }
}
