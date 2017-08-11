import UIKit

class RecipiesTableViewController: UITableViewController {

    var recipes = [Recipe]()
    var keyToPass: String!
//    var imageToPass: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(CustomRecipeCell.self)
       
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
        
        self.navigationItem.rightBarButtonItem = addBarButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        loadRecipesFromDatabase()        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CustomRecipeCell.self, for: indexPath)
        
        cell.recipeTitleLabel.text = recipes[indexPath.row].title
        cell.recipeCookTimeLabel.text = "Cook time: \(recipes[indexPath.row].cookingTime) min"
//        cell.recipeImage.image = recipes[indexPath.row].imageURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let recipe = recipes[indexPath.row]
        let detailController = DetailViewController(recipe: recipe)
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedRecipe = recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            // Delete recipe from database
//            Database.shared.connection.readWrite { (transaction) in
//                let deleteKey = transaction.allKeys(inCollection: self.databaseCollection)[indexPath.row]
//                transaction.removeObject(forKey: deleteKey, inCollection: self.databaseCollection)
//                print(transaction.allKeys(inCollection: self.databaseCollection))
//            }

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
            let title = alertController.textFields![0].text ?? ""
            let cookingTime = Int((alertController.textFields?[1].text)!) ?? 0

            Database.shared.create(title: title, cookingTime: cookingTime, imageURL: nil) { recipe in
                self.recipes.append(recipe)
                self.tableView.reloadData()
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
        Database.shared.read { recipes in
            self.recipes = recipes
            self.tableView.reloadData()
        }
    }
}
