import UIKit

class DetailView: UIView {
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!

    var recipe: Recipe? {
        didSet {
            recipeTitleLabel.text = recipe?.title ?? ""
            cookTimeLabel.text = "Estimated cook time: \(recipe?.cookingTime ?? 0) minutes"
            recipeImageView.image = #imageLiteral(resourceName: "standardRecipeImage")
        }
    }
}
