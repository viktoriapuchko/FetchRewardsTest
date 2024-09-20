//
//  MealsModel.swift
//  Recipes
//
//  Created by Viktoria Puchko on 9/14/24.
//

import Foundation
import SwiftUI

struct IngredientAndMeasure: Equatable, Hashable, Codable, Identifiable  {
    var id: Int
    let ingredientName: String
    let measure: String
}

struct MealsModel: Codable, Hashable {
    var meals: [MealModel]
}

struct MealModel: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var instructions: String?
    var ingredientsAndMeasure: [IngredientAndMeasure]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case ingredientsAndMeasure
    }
    
    private struct DynamicCodingKeys: CodingKey {
        
        var  stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(id: String, name: String, ingredientsAndMeasure: [IngredientAndMeasure]) {
        self.id = id
        self.name = name
        self.ingredientsAndMeasure = ingredientsAndMeasure
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.instructions = try values.decodeIfPresent(String.self, forKey: .instructions)
        
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var ingredientsAndMeasuresArray = [IngredientAndMeasure]()
        for i in 1...20 {
            let ingredinetString = try? container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "strIngredient\(i)"))
            let measureString =  try? container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "strMeasure\(i)"))
            
            if (ingredinetString != nil) &&
                (measureString != nil) &&
                ingredinetString?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
                measureString?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                let ingredientAndMeasure = IngredientAndMeasure(id: i, ingredientName: ingredinetString ?? "", measure: measureString ?? "")
                ingredientsAndMeasuresArray.append(ingredientAndMeasure)
            }
        }
        self.ingredientsAndMeasure = ingredientsAndMeasuresArray
    }
}
