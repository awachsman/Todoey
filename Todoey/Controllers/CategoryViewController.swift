//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//  Real file path: Macintosh HD/Users/awachsman/Library/Developer/CoreSimulator/Devices/<Latest device>/data/containers/Data/Application<latest application>/Douments/default.realm

import UIKit
import RealmSwift


// CategoryViewController is a sunclass of SwipeTableViewController.
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()  //Try to initialize a new Realm
    
    // Change array type from list of category objects to Results datatype
    var categories: Results<Category>?
    
    /*
     CoreData-specific code below is obsolete
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1  // nil coalescing operator.  If there are categories, return their count, otherwise return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell used to be defined as SwipeTableViewCell, relying on import of SwipeCellKit;  however that functionality has been moved to the SwipeTableViewController superclass. We tap into that superclass and override it as follows:
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."  // if categories exist, populate cells with categories, else populate a cell with "No categories added yet."
        
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
    // Commit changes to Realm
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        self.tableView.reloadData()  // reloadData calls all of the TableView Datasource Methods
    }
    
    
    
    func loadCategories() {
        /* Iteration 1 - obsolete - uses CoreData */
        
        /* Iteration 2 - uses Realm */
        // Fetch all of the objects that belong to the Category datatype
        categories = realm.objects(Category.self)
        
        tableView.reloadData() // reloadData calls all of the TableView Datasource Methods
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            //tableView.reloadData()
        }
    }
    
}


//The code below has been moved to SwipeTableViewController
//// In the  extension, aAdopt SwipeTableViewCellDelegate protocol
//extension CategoryViewController: SwipeTableViewCellDelegate {
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
//            // handle action by updating model with deletion
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                        
//                    }
//                } catch {
//                    print("Error deleting category, \(error)")
//                }
//                //tableView.reloadData()
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//}
