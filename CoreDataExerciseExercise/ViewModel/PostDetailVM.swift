//
//  PostDetailVM.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import Foundation
import CoreData

class PostDetailVM {
        
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Post.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        if let id = self.id {
            fetchRequest.predicate = NSPredicate(format:"%K ==[cd] %d", "id", id)
        }
        fetchRequest.fetchBatchSize = 20
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    var id: Int?
    
    init(with id: Int?) {
        self.id = id
    }
}
