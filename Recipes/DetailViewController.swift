//
//  DetailViewController.swift
//  Recipes
//
//  Created by Utheim Sverdrup, Ulrik on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var recipe: Recipe?
    var databaseKey: String?
    let databaseCollection = "collection"
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editRecipe))

        self.navigationItem.rightBarButtonItem = editBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipeTitleLabel.text = recipe?.title ?? ""
        cookTimeLabel.text = "Estimated cook time: \(recipe?.cookTime ?? 0) minutes"
        recipeImageView.image = recipe?.image
    }
    
    func editRecipe() {
        let alertController = UIAlertController(title: "Edit recipe", message: "Type in the new title of your recipe", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = self.recipe?.title
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Cook Time in minutes"
        }
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { alert in
            let newTitle = alertController.textFields![0].text
            let newCookTime = Int(alertController.textFields![1].text!)
            /*
            let newRecipe = Recipe(title: newTitle!, cookTime: newCookTime!, image: self.recipeImage)
            
            self.recipeTitleLabel.text = newTitle
            self.cookTimeLabel.text = "Estimated cook time: \(newCookTime ?? 0) minutes"
            
            DatabaseManager.shared.connection.readWrite { (transaction) in
                transaction.removeObject(forKey: self.databaseKey!, inCollection: self.databaseCollection)
                
                transaction.setObject(newRecipe, forKey: newTitle! + "Recipe", inCollection: self.databaseCollection)
                print(transaction.allKeys(inCollection: self.databaseCollection))
            }
            
            NSLog("Save Edited Recipe")*/
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
