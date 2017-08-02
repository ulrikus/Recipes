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
    @IBAction func editButtonPressed(_ sender: Any) {
        func addRecipe() {
            // Create the alert controller
            let alertController = UIAlertController(title: "Add recipe", message: "Type in the title of your recipe", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                
            }
            
            // Create the actions
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { alert in
                let title = alertController.textFields![0].text
                let recipe = Recipe(title: title!)
                
                
                print(title!)
                NSLog("Save Pressed")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { alert in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
