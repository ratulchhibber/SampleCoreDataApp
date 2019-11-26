//
//  CoreServiceClient.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import Foundation

enum CustomError: Error, CustomStringConvertible {
    case noInternet
    case badConnection
    case badResponse
    
    var description: String {
        switch self {
        case .noInternet:
            return "The internet connection is unavailable".localized()
        default:
            return "App is experiencing some difficulties, please try again later".localized()
        }
    }
}

class CoreServiceClient {

    func requestData(for url: URLRequest,
                     completion: @escaping (Result<[[String: AnyObject]], CustomError>) -> ()) {
        
        do {
            let reachability = try Reachability()
            if reachability.connection == .unavailable {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.noInternet))
                }
            } else {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                         let data = data, error == nil else {
                            DispatchQueue.main.async {
                                completion(.failure(CustomError.badConnection))
                            }
                        return
                    }
                    
                    guard
                        let urlResponse = response as? HTTPURLResponse,
                        (200...299).contains(urlResponse.statusCode)  else {
                            DispatchQueue.main.async {
                                completion(.failure(CustomError.badResponse))
                            }
                            return
                    }
                    
                   do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                            DispatchQueue.main.async {
                                completion(.success(json))
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(.failure(CustomError.badResponse))
                            }
                    }
                    } catch _ {
                        DispatchQueue.main.async {
                            completion(.failure(CustomError.badResponse))
                        }
                    }
                }.resume()
            }
            
        } catch _ {  }
    }
}
