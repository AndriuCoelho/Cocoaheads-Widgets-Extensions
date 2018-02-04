//
//  TodayViewController.swift
//  Rangos
//
//  Created by Ândriu Coelho on 25/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var context: NSManagedObjectContext?
    var fetchedResultsController:NSFetchedResultsController<Order>?
    
    // MARK: - View Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContainerSettings()
        getMeals()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - Methods
    
    func loadContainerSettings() {
        let storeURL =  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rango")!.appendingPathComponent("Rango.sqlite")
        let modelURL = Bundle.main.url(forResource: "Rango", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: modelURL!)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print(error.localizedDescription)
        }
        context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context?.persistentStoreCoordinator = coordinator
    }
    
    func getMeals() {
        let fetchRequest:NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func convertToMeal(index:Int) -> Meal? {
        guard let list = fetchedResultsController?.fetchedObjects else { return nil }
        let orders = list.flatMap { $0.meal?.allObjects as! [Meal] }
        let meal = orders[index]
        
        return meal
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let orders = fetchedResultsController?.fetchedObjects else { return 0 }
        let meals = orders.flatMap { $0.meal?.allObjects as! [Meal] }
        
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "food-cell", for: indexPath) as! WidgetCollectionViewCell
        guard let meal = convertToMeal(index: indexPath.row) else { return cell }
        cell.customizeCell(meal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = convertToMeal(index: indexPath.row)
        let path = String(format: "rango://details=%@", meal!.objectID.uriRepresentation().absoluteString)
        if let url = URL(string: path) {
            extensionContext?.open(url, completionHandler: nil)
        }

    }
}
