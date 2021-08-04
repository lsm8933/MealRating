//
//  MealRatingTests.swift
//  MealRatingTests
//
//  Created by Jing Li on 3/31/21.
//

import XCTest
@testable import MealRating

class MealRatingTests: XCTestCase {

    // MARK: Meal Class Tests
    func testMealInitializationSucceeds() {
        let zeroRatingMeal = Meal(name: "Meal1", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        let normalRatingMeal = Meal.init(name: "Meal2", photo: nil, rating: 3)
        XCTAssertNotNil(normalRatingMeal)
    }
    
    func testMealInitializationFails() {
        let oddRatingMeal = Meal(name: "Meal3", photo: nil, rating: -6)
        XCTAssertNil(oddRatingMeal)
        
        let emptyNameMeal = Meal.init(name: "", photo: nil, rating: 4)
        XCTAssertNil(emptyNameMeal)
    }

}
