//
//  MealDetailsViewController.swift
//  Rango
//
//  Created by Ândriu Coelho on 25/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit
import CoreData

class MealDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var labelNameFood: UILabel!
    @IBOutlet weak var textViewDescriptionFood: UITextView!
    @IBOutlet weak var labelPriceFood: UILabel!
    
    // MARK: - Properties
    
    var meal:Meal?
    var objectId:String?
    var fetchedResultsController:NSFetchedResultsController<Meal>?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getMeals()
        setupUI()
    }
    
    // MARK: - Methods
    
    func getMeals() {
        if meal == nil {
            let fetchRequest:NSFetchRequest<Meal> = Meal.fetchRequest()
            let descriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchedResultsController?.performFetch()
                guard let mealList = fetchedResultsController?.fetchedObjects else { return }
                for currentMeal in mealList {
                    guard let currentId = currentMeal.objectID.uriRepresentation().absoluteString.components(separatedBy: "/").last else { return }
                    if currentId == objectId {
                        meal = currentMeal
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupUI() {
        guard let meal = meal else { return }
        labelNameFood.text = meal.name
        textViewDescriptionFood.text = meal.descriptive
        labelPriceFood.text = String(format: "R$ %.2f", meal.price)
        
        guard let imageName = meal.image else { return }
        guard let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rango")?.appendingPathComponent("Images").appendingPathComponent(imageName) else { return }
        guard let result = NSData(contentsOf: path) else { return }
        imageFood.image = UIImage(data: result as Data)
    }
    
    // MARK: - Actions
    
    @IBAction func buttonBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBuyFood(_ sender: UIButton) {
        guard let meal = meal else { return }
        let order = Order(context: context)
        order.addToMeal(meal)
        do {
            try context.save()
            let alert = Alerts().showAlert(title: "Atenção", message: "pedido realizado com sucesso!")
            present(alert, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}
