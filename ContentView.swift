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
        VStack {
            Text("Categories")
                .font(.largeTitle)
            List(viewModel.quizCategories, id: \.self) { category in
                Text(category)
            }
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
