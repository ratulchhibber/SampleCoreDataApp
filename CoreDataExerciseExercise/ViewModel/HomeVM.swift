//
//  HomeVM.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import Foundation
import CoreData

class HomeVM {
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Post.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.fetchBatchSize = 20
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
        
    func fetchPosts(completion: @escaping (_ error: CustomError?) -> ()) {
        Services().fetchPosts { result in
            switch result {
              case .success(let data):
                let backgroundContext = CoreDataStack.shared.backgroundContext
                CoreDataStack.shared.clearData(for: backgroundContext,
                                               entity: "Post")
                self.saveInCoreDataWith(context: backgroundContext,
                                        data: data)
              completion(nil)
              case .failure(let error):
                completion(error)
            }
        }
    }
        
    func saveInCoreDataWith(context: NSManagedObjectContext,
                            data: [[String: AnyObject]]) {
        if data.isEmpty { return }
        data.forEach { self.createPostEntityFrom(for: context, dictionary: $0) }
        CoreDataStack.shared.save(context: context)
    }
    
    private func createPostEntityFrom(for context: NSManagedObjectContext,
                                      dictionary: [String: AnyObject]) {
        guard let post = NSEntityDescription
                        .insertNewObject(forEntityName: "Post",
                                         into: context) as? Post else { return }
        if let userId = dictionary["userId"] as? Int {
            post.userId = Int32(userId)
        }
        if let id = dictionary["id"] as? Int {
            post.id = Int32(id)
        }
        post.title = dictionary["title"] as? String
        post.body = dictionary["body"] as? String
    }
}
