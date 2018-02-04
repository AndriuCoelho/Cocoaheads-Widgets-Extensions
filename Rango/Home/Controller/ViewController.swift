//
//  ViewController.swift
//  Rango
//
//  Created by Ândriu Coelho on 23/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var fetchedResultsController:NSFetchedResultsController<Meal>?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getMeals()
    }
    
    // MARK: - Methods
    
    func getMeals() {
        let fetchRequest:NSFetchRequest<Meal> = Meal.fetchRequest()
        let descriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [descriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "food-cell", for: indexPath) as! FoodCollectionViewCell
        guard let meal = fetchedResultsController?.fetchedObjects![indexPath.row] else { return cell }
        cell.customizeCell(meal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = fetchedResultsController?.fetchedObjects![indexPath.item]
        let mealDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as! MealDetailsViewController
        mealDetails.meal = meal
        navigationController?.pushViewController(mealDetails, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 10, height: 165)
    }
    
    // MARK: - FetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        foodCollectionView.reloadData()
    }
    


}

