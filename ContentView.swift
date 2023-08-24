//
//  ContentView.swift
//  SitecoreQuizApp
//
//  Created by Ricardo Herrera Petit on 6/11/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = QuizViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.quizCategories, id: \.self) { category in
                Text(category)
            }
            .refreshable {
                viewModel.fetchQuizCategories()
            }
            .navigationTitle("Categories")
        }
        .onAppear {
            viewModel.fetchQuizCategories()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
