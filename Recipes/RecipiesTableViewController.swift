//
//  RecipiesTableViewController.swift
//  Recipes
//
//  Created by Ulrik Utheim Sverdrup on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

class DatabaseManager {

    let database: YapDatabase
    let connection: YapDatabaseConnection
    
    static let shared: DatabaseManager = {
        return DatabaseManager(database: YapDatabase(path: String.databasePath()))
    }()
    
    private init(database: YapDatabase) {
        self.database = database
        self.connection = database.newConnection()
    }
}

class RecipiesTableViewController: UITableViewController {

    let segueIdentifier = "recipeDetailSegue"
    let databaseCollection = "collection"
    let reuseIdentifier = "CustomRecipeCell"
    var recipes = [Recipe]()
    var titleToPass: String!
    var cookTimeToPass = Int()
    var keyToPass: String!
//    var imageToPass: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
       
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
        
        self.navigationItem.rightBarButtonItem = addBarButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        loadRecipesFromDatabase()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateRecipes()
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! CustomRecipeCell
        
        cell.recipeTitleLabel.text = recipes[indexPath.row].title
        cell.recipeCookTimeLabel.text = "Cook time: \(recipes[indexPath.row].cookTime) min"
        cell.recipeImage.image = recipes[indexPath.row].image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        titleToPass = recipes[indexPath.row].title
        cookTimeToPass = recipes[indexPath.row].cookTime
//        imageToPass = recipes[indexPath.row].image
        keyToPass = titleToPass + "Recipe"
        
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedRecipe = recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete recipe from database
            DatabaseManager.shared.connection.readWrite { (transaction) in
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
        // No need since the database alphabetizes the dictionary when reloaded
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
            viewController.cookTime = cookTimeToPass
//            viewController.recipeImage = imageToPass
            viewController.databaseKey = keyToPass
        }
    }
    
    // MARK: Methods
    
    func addRecipe() {
        // Create the alert controller
        let alertController = UIAlertController(title: "Add recipe", message: "Type in the title of your recipe", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Recipe title"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Cook time in minutes"
        }
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { alert in
            let title = alertController.textFields![0].text
            let cookTime: Int? = Int((alertController.textFields?[1].text)!)
            let image = #imageLiteral(resourceName: "standardRecipeImage")
            
            let recipe = Recipe(title: title!, cookTime: cookTime!, image: image)
            
            if title == "" {
                NSLog("Empty recipe title. Nothing is saved.")
            } else {
                self.recipes.append(recipe)
                self.tableView.reloadData()
                
                // Save recipe to database
                DatabaseManager.shared.connection.readWrite { (transaction) in
                    transaction.setObject(recipe, forKey: (recipe.title + "Recipe"), inCollection: self.databaseCollection)
                    print(transaction.allKeys(inCollection: self.databaseCollection))
                }
                
                NSLog("Saved: \(recipe.title), \(recipe.cookTime) min")
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
    
    func loadRecipesFromDatabase() {
        // Read recipe from database
        DatabaseManager.shared.connection.readWrite { (transaction) in
            let allKeys = transaction.allKeys(inCollection: self.databaseCollection)
            print(allKeys)
            print("\(allKeys.count) recipes:")
            print("")
            
            for key in allKeys {
                guard let recipe = transaction.object(forKey: key, inCollection: self.databaseCollection) as? Recipe else {
                    return
                }
                print("Recipe title: " + recipe.title)
                print("Cook time: \(recipe.cookTime)")
                print("")
                
                self.recipes.append(recipe)
            }
        }
    }
    
    func updateRecipes() {
        // Basically does the same as loadRecipesFromDatabase(), but without the print()-statements and that this method deletes the array before populating it again
        DatabaseManager.shared.connection.readWrite { (transaction) in
            let allKeys = transaction.allKeys(inCollection: self.databaseCollection)
            self.recipes.removeAll()
            
            for key in allKeys {
                guard let recipe = transaction.object(forKey: key, inCollection: self.databaseCollection) as? Recipe else {
                    return
                }
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
