//
//  Meal.swift
//  MealRating
//
//  Created by Jing Li on 8/2/21.
//

import UIKit

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
