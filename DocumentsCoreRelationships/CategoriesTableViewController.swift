//
//  CategoriesTableViewController.swift
//  DocumentsCoreRelationships
//
//  Created by Grant Maloney on 9/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {

    @IBAction func addCategory(_ sender: Any) {
        self.performSegue(withIdentifier: "showCategory", sender: self)
    }
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
    }
    
    func loadCategories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            createFailAlert(message: "Failed to load data", error: error as! String, parent: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryReuse", for: indexPath)

        if let cell = cell as? CategoriesTableViewCell {
            cell.categoryLabel.text = categories[indexPath.row].name
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDocuments", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") {
            action, index in
            self.handleDelete(indexPath: indexPath)
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") {
            action, index in
            self.handleEdit(indexPath: indexPath)
        }
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row {
            if let destination = segue.destination as? DocumentsTableViewController {
                destination.category = categories[row]
            }
        }
    }
    
    func handleEdit(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Enter a new category name", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            if let updatedName = textField?.text {
                if updatedName == "" {
                    return
                } else {
                    self.categories[indexPath.row].updateName(name: updatedName)
                    
                    if let context = self.categories[indexPath.row].managedObjectContext {
                        do {
                            try context.save()
                        } catch {
                            createFailAlert(message: "Failed to save", error: error as! String, parent: self)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                return
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDelete(indexPath: IndexPath) {
        if let documents = categories[indexPath.row].rawDocuments{
            if documents.count == 0 {
                delete(indexPath: indexPath)
                return;
            }
        }
        
        let alert = UIAlertController(title: "Are you sure you want to delete?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // Delete the row from the data source
            self.delete(indexPath: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            return
        }))
        
        self.present(alert, animated: true)
    }
    
    func delete(indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        
        if let managedObjectContext = category.managedObjectContext {
            managedObjectContext.delete(category)
            
            do {
                try managedObjectContext.save()
                self.categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                createFailAlert(message: "Delete failed", error: error as! String, parent: self)
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
