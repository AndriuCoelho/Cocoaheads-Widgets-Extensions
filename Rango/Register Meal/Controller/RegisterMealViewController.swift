//
//  RegisterMealViewController.swift
//  Rango
//
//  Created by Ândriu Coelho on 24/01/18.
//  Copyright © 2018 Andriu. All rights reserved.
//

import UIKit
import CoreData

class RegisterMealViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewPhotograph: UIView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    @IBOutlet weak var textFieldPrice: UITextField!
    @IBOutlet weak var imageMeal: UIImageView!
    @IBOutlet weak var buttonPhoto: UIButton!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    
    func setup() {
        viewPhotograph.layer.cornerRadius = viewPhotograph.layer.frame.width / 2
        viewPhotograph.layer.borderWidth = 0.5
        viewPhotograph.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    // MARK: - ImagePickerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageFromLibrary = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageMeal.image = imageFromLibrary
            buttonPhoto.setImage(UIImage(named: ""), for: .normal)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func buttonBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func buttonRegister(_ sender: UIButton) {
        
        let meal = Meal(context: context)
        
        guard let name = textFieldName.text else { return }
        guard let description = textFieldDescription.text else { return }
        guard let price = textFieldPrice.text as NSString? else { return }
        guard let image = imageMeal.image else { return }
        
        let fileName = String(format: "%@.png", meal.objectID.uriRepresentation().lastPathComponent)
        
        guard let data = UIImagePNGRepresentation(image) else { return }
        
        let fileManager = FileManager.default
        guard let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rango") else { return }
        let url = directory.appendingPathComponent("Images")
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
        
        meal.name = name
        meal.descriptive = description
        meal.price = price.doubleValue
        meal.image = fileName
        
        saveMeal { (isSaved) in
            if isSaved {
                do {
                    try data.write(to: url.appendingPathComponent(fileName))
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveMeal(_ completion:(_ save:Bool) -> Void) {
        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
