//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Now using Realm:
    //Try to initialize a new Realm
    
    let realm = try! Realm()

    // Create array of category objects, imnitialized as an empty array
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadCategories()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        //cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
       
    //MARK: - TabelView Delegate Methods
    
    // This method is triggered when we select a row in the Ctegory table view.  When selected, it should perform the segue named "goToItems" and display the ToDoListVC 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a constant which stores a reference to our destination view controller
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Grab the category that corresposnds to the selected cell.  You get this by getting the indexPathForSelectedRow
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Adsd New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  // 1
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)  // 2
        let action = UIAlertAction(title: "Add", style: .default) { (action) in  // 3
           /* Iteration 1 (obsolete) - uses CoreData whose classes were category and Item
             let newCategory = Category(context: self.context)
             */
            /*
             Iteration 2 - uses Realm
             */
            let newCategory = Category()
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            /* Iteration 1 - obsolete - uses CoreData
             self.saveCategories()
             */
            /* Iteration 2 - using Realm*/
            self.save(category: newCategory)
            
        }
        alert.addAction(action) // 4
        
        alert.addTextField { (field) in // 5
            
        textField = field
        textField.placeholder = "Add a new category"
        }
        
        
        
        present(alert, animated: true, completion: nil)  // 6
        
    }
    
    //MARK: - Data Manipulation methods
    /*
    Iteration 1 - obsolete - used CoreData
     
     func saveCategories() {
         do {
             try context.save()
         } catch {
             print("Error saving category, \(error)")
         }
         
         // refresh the tableView to display added item
         self.tableView.reloadData()
     }
    */
    
    /*Iteration 2 - uses Realm */
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        // refresh the tableView to display added item
        self.tableView.reloadData()
    }
 
    /* Iteration 1 - bsolete - uses CoreData
     
     func loadCategories() {

         // App must speak to the context.  Since this can throw an error, need to encapsulate in a do/try/catch.  Assign the results of the context.fetchrequest to itemArray
         let request : NSFetchRequest<Category> = Category.fetchRequest()

         do {
             categories = try context.fetch(request)
         } catch {
             print("Error loading categories \(error)")
         }
         tableView.reloadData()
     }
     */
}
