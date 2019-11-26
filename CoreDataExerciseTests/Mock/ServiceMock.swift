//
//  ServiceMock.swift
//  CoreDataExerciseTests
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import Foundation

class ServiceMock {
    
    static func getJsonAsData(filename: String) -> Data? {

        if let path = Bundle(for: self).path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        } else {
            fatalError("File \(filename) does not exist")
        }
        return nil
    }
}
