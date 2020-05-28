//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()  //Try to initialize a new Realm

    // Change array type from list of category objects to Results datatype
    //var categories = [Category]()
    var categories: Results<Category>?
    
    /*
     Delete CoreData-specific code below
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1  // nil coalescing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  // 1
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)  // 2
        let action = UIAlertAction(title: "Add", style: .default) { (action) in  // 3
           /* Iteration 1 (obsolete) - used CoreData */
            
            //Iteration 2 - uses Realm
            let newCategory = Category()
            newCategory.name = textField.text!
            /* Results datatype is autoupdating container, no longer need append
             self.categories.append(newCategory)
             */
            
            
            /* Saving data
             Iteration 1 - obsolete - used CoreData */
            
            // Iteration 2 - using Realm
            self.save(category: newCategory)
            
        }
        alert.addAction(action) // 4
        
        alert.addTextField { (field) in // 5
            
        textField = field
        textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)  // 6o
    }
    
    //MARK: - Data Manipulation methods
    /*
    Iteration 1 - obsolete - used CoreData */
    
    /*Iteration 2 - use Realm */
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
 
    
     
    func loadCategories() {
        /* Iteration 1 - obsolete - uses CoreData */
        
        /* Iteration 2 - uses Realm */
        categories = realm.objects(Category.self)

         tableView.reloadData()
     }
    
}
