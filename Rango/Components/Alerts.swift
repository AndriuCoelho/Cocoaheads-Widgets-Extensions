//
//  Alerts.swift
//  Rango
//
//  Created by Ândriu Coelho on 25/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit

class Alerts: NSObject {
    
    func showAlert(title:String, message:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(button)
        
        return alert
    }
 
}
