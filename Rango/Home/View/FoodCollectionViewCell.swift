//
//  FoodCollectionViewCell.swift
//  Rango
//
//  Created by Ândriu Coelho on 23/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var labelDescriptionFood: UILabel!
    @IBOutlet weak var labelPriceFood: UILabel!
    @IBOutlet weak var labelNameFood: UILabel!
    
    // MARK: - Methods
    
    func customizeCell(_ meal:Meal) {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 10
        
        labelNameFood.text = meal.name
        labelPriceFood.text = String(format: "R$ %.2f", meal.price)
        labelDescriptionFood.text = meal.descriptive
        
        guard let imageName = meal.image else { return }
        
        guard let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rango")?.appendingPathComponent("Images").appendingPathComponent(imageName) else { return }
        
        guard let result = NSData(contentsOf: path) else { return }
        imageFood.image = UIImage(data: result as Data)
    }
}
