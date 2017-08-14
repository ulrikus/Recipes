import UIKit

class DetailViewController: UIViewController {
    private unowned var recipe: Recipe
    var databaseKey: String?
    let databaseCollection = "collection"

    init(recipe: Recipe) {
        self.recipe = recipe

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var customView: DetailView { return self.view as! DetailView }

    override func loadView() {
        let view = UIView.instanceFromNib() as DetailView
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editRecipe))

        self.navigationItem.rightBarButtonItem = editBarButton
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        customView.recipe = self.recipe
    }
    
    func editRecipe() {
        let alertController = UIAlertController(title: "Edit recipe", message: "Type in the new title of your recipe", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = self.recipe.title
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Cook Time in minutes"
        }
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { alert in
            let newTitle = alertController.textFields![0].text
            let newCookingTime = Int(alertController.textFields![1].text!)
            
            Database.shared.update(id: self.recipe.id, title: newTitle!, cookingTime: newCookingTime!, imageURL: nil, completion: { recipe in
                self.recipe = recipe
                self.customView.recipe = self.recipe
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { alert in
            NSLog("Cancel Edit Recipe")
        }
        
        // Add the actions
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
