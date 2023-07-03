//
//  QuizViewModel.swift
//  SitecoreQuizApp
//
//  Created by Ricardo Herrera Petit on 6/11/23.
//

import Foundation

import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var quizCategories = [String]()
    private var networkManager = NetworkManager()
    
    func fetchQuizCategories() {
        networkManager.fetchQuizCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.quizCategories = categories
                case .failure(let error):
                    print("Failed to fetch quiz categories: \(error)")
                }
            }
        }
    }
}
