//
//  String+Localizable.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String{
        return NSLocalizedString(self, tableName:"Localizable", comment: "")
    }
}
