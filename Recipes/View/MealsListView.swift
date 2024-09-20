//
//  ContentView.swift
//  Recipes
//
//  Created by Viktoria Puchko on 9/14/24.
//

import SwiftUI

struct MealsListView: View {
    
    @State private var loadingState: MealsLoadingStates = MealsLoadingStates.loading
    @State private var listOfMeals: MealsModel = MealsModel(meals: [])
    
    var body: some View {
        Text("List of meals")
            .frame(alignment: .center)
            .font(.system(size: 18))
        NavigationView {
            switch loadingState {
            case .content:
                List(listOfMeals.meals) { meal in
                    MealRow(meal: meal)
                }
            case .loading:
                Text("Loading...")
                    .task {
                        await self.loadTask()
                    }
            case .failfure(let error):
                Text("Something went wrong! \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
    
    private func loadTask() async {
        do {
            self.loadingState = .loading
            self.listOfMeals = try await ApiService.fetchListOfMeals()
            self.loadingState = .content
        }
        catch  {
            self.loadingState = .failfure(error)
        }
    }
}

#Preview {
    MealsListView()
}

struct MealRow: View {
    var meal: MealModel
    var body: some View {
        HStack{
            NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                Text(verbatim: meal.name)
            }
        }
    }
}

#Preview {
    MealRow(meal: MealModel(id: "1", name: "hbghvhjgf", ingredientsAndMeasure: []))
}

enum MealsLoadingStates {
    case loading
    case content
    case failfure(Error)
}

