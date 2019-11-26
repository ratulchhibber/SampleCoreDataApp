//
//  Services.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//
import Foundation

protocol ServiceEndpointProtocol {
    var path: String { get }
}

class Services {
    
    enum Endpoint: ServiceEndpointProtocol {
        case posts, comments
        
        var path: String {
            switch self {
            case .posts:
                return "\(baseURL)/posts"
            case .comments:
                return "\(baseURL)/comments?postId="
            }
        }
        
        private var baseURL: String {
            return "https://jsonplaceholder.typicode.com"
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[[String: AnyObject]], CustomError>) -> ()) {
        guard let url = URL(string: "\(Endpoint.posts.path)") else { return }
        
        let request = URLRequest(url: url)

        CoreServiceClient().requestData(for: request) { result in
            completion(result)
        }
    }
    
    
}
