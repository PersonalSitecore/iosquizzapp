//
//  NetworkManager.swift
//  SitecoreQuizApp
//
//  Created by Ricardo Herrera Petit on 6/11/23.
//

import Foundation

class NetworkManager: NSObject, URLSessionDelegate {
    let url = URL(string: "https://www.headlessapp.localhost/sitecore/api/graph/edge")!
        var session: URLSession!

        override init() {
            super.init()
            self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        }

    func fetchQuizCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("{F025A57B-C02F-4959-9B3D-2D72F579656A}", forHTTPHeaderField: "sc_apikey")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "query": """
                query {
                  item(path: "/sitecore/content/HeadlessApp/Content/Quizzes", language: "en") {
                    id
                    children(includeTemplateIDs: ["2DD80D3EB1DA4DF0A915DC160A459079"]) {
                       results {
                           id,
                           name
                       }
                    }
                  }
                }
                """
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }

            do {
                let result = try JSONDecoder().decode(QueryResult.self, from: data)
                let categories = result.data.item.children.results.map { $0.name }
                completion(.success(categories))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Add a new function in NetworkManager to fetch quiz details for the selected category
    func fetchQuizDetails(forCategory category: String, completion: @escaping (Result<[String], Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("{F025A57B-C02F-4959-9B3D-2D72F579656A}", forHTTPHeaderField: "sc_apikey")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "query": """
                query {
                  item(path: "/sitecore/content/HeadlessApp/Content/Quizzes/\(category)", language: "en") {
                    id
                    children {
                       results {
                           id,
                           name
                       }
                    }
                  }
                }
                """
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }

            do {
                let result = try JSONDecoder().decode(QueryResult.self, from: data)
                let details = result.data.item.children.results.map { $0.name }
                completion(.success(details))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }


    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

struct QueryResult: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let item: Item
}

struct Item: Codable {
    let children: Children
}

struct Children: Codable {
    let results: [ResultElement]
}

struct ResultElement: Codable {
    let id, name: String
}
