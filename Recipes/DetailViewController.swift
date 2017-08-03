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
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editRecipe))

        self.navigationItem.rightBarButtonItem = editBarButton
    }
    
    func editRecipe() {
        let alertController = UIAlertController(title: "Edit recipe", message: "Type in the new title of your recipe", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = self.recipeTitle
        }
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { alert in
            let newTitle = alertController.textFields![0].text
            let recipe = Recipe(title: newTitle!)
            
            self.recipeTitleLabel.text = newTitle
            
            // Do something to change the array of Recipes so that the change is saved
            
            NSLog("Save Edited Recipe")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { alert in
            NSLog("Cancel Edit Recipe")
        }
        
        // Add the actions
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
