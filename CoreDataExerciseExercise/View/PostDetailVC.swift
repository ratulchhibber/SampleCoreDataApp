//
//  PostDetailVC.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import UIKit
import CoreData

class PostDetailVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private lazy var viewModel = PostDetailVM(with: nil)
    
    func configure(with viewModel: PostDetailVM) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selected Post Content".localized()
        setupFRC()
    }
    
    private func setupFRC() {
        viewModel.fetchedResultsController.delegate = self
        do { try viewModel.fetchedResultsController.performFetch() }
        catch _  { }
    }
    
}

extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell",
                                                 for: indexPath)
        if let post = viewModel.fetchedResultsController.object(at: indexPath) as? Post {
            cell.textLabel?.text = post.body
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
}

extension PostDetailVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
