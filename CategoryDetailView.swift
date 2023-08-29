//
//  CategoryDetailView.swift
//  SitecoreQuizApp
//
//  Created by Ricardo Herrera Petit on 8/29/23.
//
import SwiftUI

// Create a new SwiftUI view to display details for the selected category
struct CategoryDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    let category: String  // No need to be a Binding, just a simple String
    
    var body: some View {
        List(viewModel.quizDetails, id: \.self) { detail in
            Text(detail)
        }
        .navigationTitle("\(category) Details")
        .onAppear {
            viewModel.fetchQuizDetails(forCategory: category)
        }
    }
}
