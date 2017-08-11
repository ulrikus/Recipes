import UIKit

class Recipe: NSObject, NSCoding {
    
    enum Keys: String {
        case id
        case title
        case cookingTime
        case imageURL
    }
    
    var title: String
    var cookingTime: Int
    var imageURL: String?
    let id: String
    
    init(title: String, cookingTime: Int, imageURL: String?) {
        self.id = UUID().uuidString
        self.title = title
        self.cookingTime = cookingTime
        self.imageURL = imageURL
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: Keys.id.rawValue) as! String

        if let titleObject = aDecoder.decodeObject(forKey: Keys.title.rawValue) as? String {
            title = titleObject
        } else {
            title = "No title"
        }
        
        let cookTimeObject = aDecoder.decodeInteger(forKey: Keys.cookingTime.rawValue)
        cookingTime = cookTimeObject
        
        if let imageUrlObject = aDecoder.decodeObject(forKey: Keys.imageURL.rawValue) as? String {
            imageURL = imageUrlObject
        } else {
            imageURL = nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id.rawValue)
        aCoder.encode(title, forKey: Keys.title.rawValue)
        aCoder.encode(cookingTime, forKey: Keys.cookingTime.rawValue)
        aCoder.encode(imageURL, forKey: Keys.imageURL.rawValue)
    }
}
