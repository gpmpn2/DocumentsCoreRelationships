//
//  CategoryViewController.swift
//  DocumentsCoreRelationships
//
//  Created by Grant Maloney on 9/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func createCategory(_ sender: Any) {
        let inputName = inputField.text
        
        if inputName == "" {
            createFailAlert(message: "You can't have a blank category!", error: "", parent: self)
            return
        }
        
        if let name = inputName {
            let category = Category(name: name)
        
            if let category = category {
                do {
                    let managedObjectContext = category.managedObjectContext
                    try managedObjectContext?.save()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Category could not be saved.")
                }
            } else {
                print("Category could not be created.")
            }
        }
    }
    
    @IBOutlet weak var inputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
