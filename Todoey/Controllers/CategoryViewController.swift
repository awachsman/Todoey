//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//  Realm file path: Macintosh HD/Users/awachsman/Library/Developer/CoreSimulator/Devices /<Latest device>/data/containers/Data/Application<latest application>/Douments/default.realm

import UIKit
import RealmSwift
import ChameleonFramework


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
        
        // Remove separator between cells
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")
            
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        let navBarColor = navBar.backgroundColor
        
        if let navBarColor = UIColor(hexString: "1D9BF6") {
            
            // Set the colors of navbar's buttons (+ and <) to be contrasting.  Settings in the line below apply to all of the bar button items in the navbar
            navBar.barTintColor = navBarColor
            
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            
            //searchBar.barTintColor = navBarColor
            
            // Set the attributes of the navBar title. This uses .largeTitleTextAttributes because we set our title to large in main.storyboard
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            
        }
        // In setting the colors of nvbar button items to constrasting, we find that although UIColor returns an optional, the contrasting keyword does not.  Therefore, use if...let
        
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1  // nil coalescing operator.  If there are categories, return their count, otherwise return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell used to be defined as SwipeTableViewCell, relying on import of SwipeCellKit;  however that functionality has been moved to the SwipeTableViewController superclass. We tap into that superclass and override it as follows:
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        // If categories exist, 1) populate cells with categories, else populate a cell with "No categories added yet." 2) Get the hex backgroundColor from the Categories table;  if the retrieved value is not nil, use that value from the table, otherwise use default of 1D9BF6
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No categories added yet."
            
        //cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].backgroundColor ?? "1D9BF6")
            
            guard let categoryColor = UIColor(hexString: category.backgroundColor) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            // Apply a contrasting color for text based on computed backroundColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
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
            
            // Save the color in the backgroundColor field of the Categories table
            newCategory.backgroundColor = RandomFlatColor().hexValue()
            
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
