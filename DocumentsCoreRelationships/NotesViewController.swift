//
//  NotesViewController.swift
//  DocumentsCoreRelationships
//
//  Created by Grant Maloney on 9/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func textChanged(_ sender: Any) {
        self.navigationItem.title = nameTextField.text
    }
    var category: Category?
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if document == nil {
            contentTextView.text = ""
            nameTextField.text = ""
            nameTextField.placeholder = "Enter document name"
        } else {
            if let content = document?.content {
                contentTextView.text = content
            }
            
            if let name = document?.name {
                nameTextField.text = name
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveDocument))
        // Do any additional setup after loading the view.
    }
    
    @objc
    func saveDocument() {
        if contentTextView.text == "" {
            createFailAlert(message: "You must enter some content!", error: "", parent: self)
            return
        }
        
        if nameTextField.text == "" {
            createFailAlert(message: "You document must have a name!", error: "", parent: self)
            return
        }
        
        if let name = nameTextField.text {
            if let content = contentTextView.text {
                if let category = category {

                    if document == nil {
                        document = Document(name: name, content: content, category: category)
                    } else {
                        document?.update(name: name, content: content, category: category)
                    }
                    
                    if let context = document?.managedObjectContext {
                        do {
                            try context.save()
                        } catch {
                            createFailAlert(message: "Failed to save", error: error as! String, parent: self)
                        }
                    }
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
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
