//
//  Meal.swift
//  MealRating
//
//  Created by Jing Li on 8/2/21.
//

import UIKit
import GRDB

struct Meal: Identifiable {
    var id: Int64?
    var name: String
    var rating: Int
    var imageData: Data?
}

extension Meal: Codable {
    enum Columns {
        static let name = Column(CodingKeys.name)
        static let rating = Column(CodingKeys.rating)
        static let imageData = Column(CodingKeys.imageData)
    }
}

extension Meal: FetchableRecord, MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Meal {
    static func newMeal() -> Meal {
        return Meal(id: nil, name: "Tofu", rating: 4, imageData: UIImage(named: "meal1")?.jpegData(compressionQuality: 0.75))
    }
    
    static func newMeals() -> [Meal] {
        return [
            Meal(id: nil, name: "Cute Buns", rating: 5, imageData: UIImage(named: "dish1")?.jpegData(compressionQuality: 1)),
            Meal(id: nil, name: "Delicious Chinese Food", rating: 4, imageData: UIImage(named: "dish2")?.jpegData(compressionQuality: 1)),
            Meal(id: nil, name: "Tasty Delight", rating: 4, imageData: UIImage(named: "dish3")?.jpegData(compressionQuality: 1))
        ]
    }
}

// Model class: Uncomment if using NSKeyedArchiver
/*
class Meal: NSObject, NSCoding {
    // constant key for data persistency using NSKeyedArchiver
    struct ArchiveKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    static let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("meals")

    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Initialization
    // failable designated initializer
    init?(name: String, photo: UIImage?, rating: Int) {
        guard !name.isEmpty else {
            return nil
        }
        
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: NSCoding initialization
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: ArchiveKey.name)
        coder.encode(photo, forKey: ArchiveKey.photo)
        coder.encode(rating, forKey: ArchiveKey.rating)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: ArchiveKey.name) as? String else {
            return nil
        }

        let photo = coder.decodeObject(forKey: ArchiveKey.photo) as? UIImage
        let rating = coder.decodeInteger(forKey: ArchiveKey.rating)
        
        // call designated initializaer
        self.init(name: name, photo: photo, rating: rating)
    }
}
 */
