//
//  MealDetailView.swift
//  Recipes
//
//  Created by Viktoria Puchko on 9/16/24.
//

import SwiftUI

struct MealDetailView: View {
    
    @State private var loadingState: MealsLoadingStates = MealsLoadingStates.loading
    @State private var mealModel: MealModel?
    private var mealID: String
    
    init(mealID: String) {
        self.mealID = mealID
    }
    
    var body: some View {
        HStack {
            switch loadingState {
            case .content:
                VStack {
                    Text(verbatim: self.mealModel!.name)
                        .padding(5)
                    Text(verbatim: self.mealModel?.instructions ?? "")
                        .safeAreaPadding(10)
                    List(self.mealModel!.ingredientsAndMeasure) { ingredientAndMeasure in
                        HStack {
                            Text(verbatim: ingredientAndMeasure.ingredientName)
                            Spacer()
                            Text(verbatim: ingredientAndMeasure.measure)
                        }
                    }
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
            self.mealModel = try await ApiService.fetchMeal(mealID: self.mealID)
            self.loadingState = .content
        }
        catch  {
            self.loadingState = .failfure(error)
        }
    }
}

#Preview {
    MealDetailView(mealID: "1")
}
