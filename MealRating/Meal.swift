//
//  Meal.swift
//  MealRating
//
//  Created by Jing Li on 8/2/21.
//

import UIKit

class Meal {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // failable initializer: return Meal?, needs to be unwrapped before use.
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
}
