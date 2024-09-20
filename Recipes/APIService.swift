//
//  APIService.swift
//  Recipes
//
//  Created by Viktoria Puchko on 9/14/24.
//

import Foundation

class ApiService {
    static func fetchListOfMeals() async throws -> MealsModel {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
        else {
            throw ApiErrors.invalidURL
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let listOfMeals = try JSONDecoder().decode(MealsModel.self, from: data)
        return listOfMeals
    }
    
    static func fetchMeal(mealID: String)  async throws -> MealModel {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")
        else {
            throw ApiErrors.invalidURL
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let listOfMeals = try JSONDecoder().decode(MealsModel.self, from: data)
        if listOfMeals.meals.isEmpty {
            throw ApiErrors.notFound
        }
        return listOfMeals.meals[0]
    }
    
    enum ApiErrors: Error {
        case invalidURL
        case notFound
    }
}

