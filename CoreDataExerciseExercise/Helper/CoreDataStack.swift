//
//  CoreDataStack.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataExercise")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return CoreDataStack.shared.persistentContainer.viewContext
    }()
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                if let main = context.parent {
                    main.performAndWait({ () -> Void in
                        do {
                            try main.save()
                        } catch let error {
                            NSLog("Unresolved error \(error), \(error.localizedDescription)")
                        }
                    })
                }
            } catch let error {
                NSLog("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataStack {
    func clearData(for context: NSManagedObjectContext,
                   entity: String) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.shared.save(context: context)
            } catch _ { }
        }
    }
}
