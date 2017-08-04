//
//  RecipiesTableViewController.swift
//  Recipes
//
//  Created by Ulrik Utheim Sverdrup on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

class RecipiesTableViewController: UITableViewController {

    let segueIdentifier = "recipeDetailSegue"
    let databaseCollection = "collection"
    var recipes = [Recipe]()
    var titleToPass: String!
    var keyToPass: String!
    
    lazy var database: YapDatabase = {
        let database = YapDatabase(path: String.databasePath())
        return database
    }()
    lazy var connection: YapDatabaseConnection = {
       return self.database.newConnection()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
        
        self.navigationItem.rightBarButtonItem = addBarButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        loadRecipes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "recipeCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        cell?.textLabel?.text = recipes[indexPath.row].title
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        titleToPass = currentCell.textLabel?.text
        keyToPass = titleToPass + "Recipe"
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedRecipe = recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete recipe from database
            connection.readWrite { (transaction) in
                let deleteKey = transaction.allKeys(inCollection: self.databaseCollection)[indexPath.row]
                transaction.removeObject(forKey: deleteKey, inCollection: self.databaseCollection)
                print(transaction.allKeys(inCollection: self.databaseCollection))
            }

            NSLog("\(deletedRecipe.title) deleted")
            
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("insert editing style")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let recipe = recipes[sourceIndexPath.row]
        recipes.remove(at: sourceIndexPath.row)
        recipes.insert(recipe, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == segueIdentifier) {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! DetailViewController
            // your new view controller should have property that will store passed value
            viewController.recipeTitle = titleToPass
            viewController.databaseKeyForValue = keyToPass
            viewController.connection = connection
            viewController.databaseCollection = databaseCollection
        }
    }
    
    // MARK: Methods
    
    func addRecipe() {
        // Create the alert controller
        let alertController = UIAlertController(title: "Add recipe", message: "Type in the title of your recipe", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Recipe title"
        }
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { alert in
            let title = alertController.textFields![0].text
            let recipe = Recipe(title: title!)
            
            if title == "" {
                NSLog("Empty recipe title. Nothing is saved.")
            } else {
                self.recipes.append(recipe)
                self.tableView.reloadData()
                
                // Save recipe to database
                self.connection.readWrite { (transaction) in
                    transaction.setObject(title, forKey: (recipe.title + "Recipe"), inCollection: self.databaseCollection)
                    print(transaction.allKeys(inCollection: self.databaseCollection))
                }
                
                NSLog("\(title!) saved")
            }
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
    
    func loadRecipes() {
        // Read recipe from database
        connection.readWrite { (transaction) in
            let allKeys = transaction.allKeys(inCollection: self.databaseCollection)
            print(allKeys)
            
            for key in allKeys {
                guard let title = transaction.object(forKey: key, inCollection: self.databaseCollection) as? String else {
                    return
                }
                let recipe = Recipe(title: title)
                self.recipes.append(recipe)
            }
        }
    }
}

extension String {
    static func databasePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let baseDir = paths.count > 0 ? paths[0] : NSTemporaryDirectory()
        
        let databaseName = "database.sqlite"
        
        return baseDir + databaseName
    }
}
