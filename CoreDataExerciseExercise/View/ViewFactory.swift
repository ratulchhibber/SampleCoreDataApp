//
//  ViewFactory.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import UIKit

class ViewFactory {
    
    private init() { }
    
    static func createDetailView(for id: Int) -> PostDetailVC? {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        guard
            let view = storyboard
                       .instantiateViewController(withIdentifier: "PostDetailVC") as? PostDetailVC else { return nil }
        let viewModel = PostDetailVM(with: id)
        view.configure(with: viewModel)
        return view
    }
}
