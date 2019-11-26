//
//  CoreDataExerciseTests.swift
//  CoreDataExerciseTests
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreDataExercise

class CoreDataExerciseTests: XCTestCase {
    
    var saveNotificationCompleteHandler: ((Notification)->())?

    private var mockData = [[String: AnyObject]]()
    
    private lazy var mockContext: NSManagedObjectContext = {
        return mockPersistentContainer.viewContext
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataExercise")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    override func setUp() {
        super.setUp()
        observeNotifications(true)
        
        if let data = ServiceMock.getJsonAsData(filename: "allPostsMock"),
            let json = try? JSONSerialization
                            .jsonObject(with: data,
                                        options: [.mutableContainers])
                            as? [[String: AnyObject]] {
            mockData = json
        }
    }
    
    override func tearDown() {
        super.tearDown()
        observeNotifications(false)
    }
    
    private func observeNotifications(_ isObserving: Bool) {
        NotificationCenter.default.removeObserver(self)
        if isObserving {
            NotificationCenter.default
            .addObserver( self,
                          selector: #selector(contextSaved(notification:)),
                          name: NSNotification.Name.NSManagedObjectContextDidSave ,
                          object: nil )
        }
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Post")
        let results = try? mockContext.fetch(request)
        return results?.count ?? 0
    }
    
    func contextSaved( notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }

    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
}

extension CoreDataExerciseTests {
    
    func testItemsInPersistentStore() {
        HomeVM().saveInCoreDataWith(context: mockContext,
                                    data: mockData)
        let items = numberOfItemsInPersistentStore()
        XCTAssert(items == 100)
    }
    
    func testClearingRecords() {
        HomeVM().saveInCoreDataWith(context: mockContext,
                                    data: mockData)
        CoreDataStack.shared.clearData(for: mockContext,
                                       entity: "Post")
        let items = numberOfItemsInPersistentStore()
        XCTAssert(items == 0)
    }
    
    func testSaveContext() {
        let expect = expectation(description: "Context Saved")

        waitForSavedNotification { (notification) in
            expect.fulfill()
        }

        HomeVM().saveInCoreDataWith(context: mockContext,
                                    data: mockData)

        waitForExpectations(timeout: 5, handler: nil)
    }
}
