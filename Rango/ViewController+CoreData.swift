//
//  ViewController+CoreData.swift
//  Rango
//
//  Created by Ândriu Coelho on 24/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
}


