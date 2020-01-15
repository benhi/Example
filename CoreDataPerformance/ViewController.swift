//
//  ViewController.swift
//  CoreDataPerformance
//
//  Created by Benjamin HALIMI on 14/01/2020.
//  Copyright © 2020 Benjamin HALIMI. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Employee>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
//        fetchedResultsController?.delegate = self
        
        ConnectionManager.shared.getAllEmployees { [weak self] array in
            DispatchQueue.main.async { [weak self] in
                
                let request: NSFetchRequest<Employee> = Employee.fetchRequest()// as! NSFetchRequest<Verse>
                request.sortDescriptors = [NSSortDescriptor(key: "name",ascending: true)]
                
                let context = CoreDataManager.shared.persistentContainer.viewContext
                self?.fetchedResultsController = NSFetchedResultsController<Employee>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                self?.fetchedResultsController?.delegate = self
                do {
                    try self?.fetchedResultsController?.performFetch()
                    self?.tableView.reloadData()
                } catch {
                    print("Failed to initialize FetchedResultsController: \(error)")
                }
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EmployeeTableViewCellID")
    }
    
    func fetchData(){
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [Employee] {
                print(results.count)
                //                for e in results {
                //                    print(e.name)
                //                }
            }
        } catch {
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCellID", for: indexPath) as? EmployeeTableViewCell else {
            fatalError("Wrong cell type dequeued")
        }
        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        //Populate the cell from the object
        
        var image: UIImage?
        if let imageData = object.image {
            image = UIImage(data: imageData)
        }
        
        cell.updateCell(with: object.name, salary: object.salary, age: object.age, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        tableView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert: tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete: tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move: break
        case .update: break
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update: tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move: tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
