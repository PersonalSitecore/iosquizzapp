//
//  QuestionDetailView.swift
//  SitecoreQuizApp
//
//  Created by Ricardo Herrera Petit on 8/29/23.
//

import SwiftUI

struct QuestionDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    let questionPath: String
    
    var body: some View {
        VStack {
            Text(viewModel.questionText)
                .font(.title)
                .padding()
            
            List(viewModel.questionOptions, id: \.self) { option in
                Text(option)
            }
        }
        .onAppear {
            viewModel.fetchQuestionDetail(forPath: questionPath)
        }
    }
}
