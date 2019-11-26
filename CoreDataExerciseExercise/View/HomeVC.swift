//
//  ViewController.swift
//  CoreDataExercise
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private lazy var viewModel = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Posts".localized()
        triggerFetchRequest()
        setupFRC()
    }
    
    private func triggerFetchRequest() {
        ActivityIndicator.shared.show(in: view)
        viewModel.fetchPosts { error in
            ActivityIndicator.shared.hide()
            guard let error = error else { return }
            self.showAlertWith(title: "Error".localized(),
                               message: error.description)
        }
    }

    private func setupFRC() {
        viewModel.fetchedResultsController.delegate = self
        do { try viewModel.fetchedResultsController.performFetch() }
        catch _  { }
    }
    
    private func showAlertWith(title: String, message: String) {
      let alertController = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok".localized(), style: .default) { (action) in
        self.dismiss(animated: true, completion: nil)
    }
     alertController.addAction(action)
     present(alertController, animated: true, completion: nil)
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell",
                                                 for: indexPath)                
        cell.textLabel?.text = "Title:".localized()
        if let post = viewModel.fetchedResultsController.object(at: indexPath) as? Post {
            cell.detailTextLabel?.text = post.title
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let post = viewModel.fetchedResultsController.object(at: indexPath) as? Post,
            let view = ViewFactory.createDetailView(for: Int(post.id)) else { return }
        navigationController?.pushViewController(view, animated: true)
    }
}

extension HomeVC: NSFetchedResultsControllerDelegate{
    
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

