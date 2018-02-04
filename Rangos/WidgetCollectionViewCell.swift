//
//  WidgetCollectionViewCell.swift
//  Rangos
//
//  Created by Ândriu Coelho on 26/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit

class WidgetCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var labelNameFood: UILabel!
    
    // MARK: - Methods
    
    func customizeCell(_ meal:Meal) {
        labelNameFood.text = meal.name
        imageFood.layer.cornerRadius = imageFood.frame.size.width/2
        imageFood.layer.masksToBounds = true
        
        guard let imageName = meal.image else { return }
        
        guard let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rango")?.appendingPathComponent("Images").appendingPathComponent(imageName) else { return }
        
        if FileManager.default.fileExists(atPath: path.path) {
            imageFood.image = UIImage(contentsOfFile: path.path)
        }
    }
    
}
