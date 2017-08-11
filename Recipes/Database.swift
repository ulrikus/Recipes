import Foundation

class Database {

    let database: YapDatabase
    let connection: YapDatabaseConnection
    let databaseCollection = "collection"

    static let shared: Database = {
        return Database(database: YapDatabase(path: String.databasePath()))
    }()

    private init(database: YapDatabase) {
        self.database = database
        self.connection = database.newConnection()
    }

    func read(completion: @escaping (([Recipe]) -> ())) {
        Database.shared.connection.readWrite { transaction in
            let allKeys = transaction.allKeys(inCollection: self.databaseCollection)
            var recipes = [Recipe]()
            for key in allKeys {
                guard let recipe = transaction.object(forKey: key, inCollection: self.databaseCollection) as? Recipe else {
                    return
                }

                recipes.append(recipe)
            }

            completion(recipes)
        }
    }

    func create(title: String, cookingTime: Int, imageURL: String?, completion: @escaping ((Recipe) -> ())) {
        let recipe = Recipe(title: title, cookingTime: cookingTime, imageURL: imageURL)

        Database.shared.connection.readWrite { transaction in
            transaction.setObject(recipe, forKey: recipe.title, inCollection: self.databaseCollection)

            completion(recipe)
        }
    }

    func update(id: String, title: String, cookingTime: Int, imageURL: String?, completion: @escaping ((Recipe) -> ())) {
        Database.shared.connection.readWrite { transaction in
            let recipe = transaction.object(forKey: id, inCollection: self.databaseCollection) as! Recipe
            recipe.title = title
            recipe.cookingTime = cookingTime
            recipe.imageURL = imageURL
            
            transaction.setObject(recipe, forKey: id, inCollection: self.databaseCollection)

            completion(recipe)
        }
    }

    func delete(id: String, completion: @escaping (() -> ())) {
        Database.shared.connection.readWrite { (transaction) in
            transaction.removeObject(forKey: id, inCollection: self.databaseCollection)

            completion()
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
