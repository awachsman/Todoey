//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

// The ToDoListViewController is the delegate for the UISearchBar
class ToDoListViewController: UITableViewController {
    /* Iteration 1 - (obsolete) - Create an array with 3 todo items which populate 3 cells in tableView.
     
     Iteration 2 - (obsolete) -
     Under MVC, array is driven by Item class initialized in Item.swift
     
     Iteration 3
     With Core Dataand creation of CatgoryVC, itemArray is filtered to  items which match selected category.  This happens in the prepare(for segue:... method in TableView Delegate Methods
     */
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()  // Create a new realm intancee
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    /* Iteration 1 - (obsolete) -
      Started with user defaults but under MVC, defaults could not save non-standard datatypes created from Item.swift. Therefore, "defaults" constant below is commented out.
     
     let defaults = UserDefaults.standard
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // History -
        /* Iteration 1 (obsolete) - User's items saved in a defaults file  which loads the tableview as follows:
         if let items = defaults.array(forKey: "TodoListArray") as? [String] {
             itemArray = items
         }
         Iteration 2 - (obsolete) - Under MVC, code above was obsoleted. Items are now initialized based on Item class, defined in Item.swift.  IBAction addButtonPressed contains  "self.defaults.set(self.itemArray, forKey: "TodoListArray")" which saves the array in the user defaults named "defaults".
        */
        
        /* Iteration 3 - Originally, we called loadItems() at this point to load items using CoreData. Note [no param provided to loadItems() below since a default param of Item.fetchRequest has been specified in the function's  definition].  We now call loadItems() to match the selected category in the didSet method when we declared the var selectedCategory
         
         loadItems()
         */
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        /*
        Create constant named item; set its value to todoItems?[indexPath].row.  This allows us to use that constant wherever itemArray[indexPath].row is called in this function
        */
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items Added."

        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    // Checkmark accessory is invoked for the selected item. Selected row flashes gray then reverts to nonselected look
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        self.saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //NOTE:  Understanding of scope for variables is necessary to follow sequence of events below.  6                        steps are:
        
        //1. Initialize textField (accessible throughout this IBAction) to hold whatever is in text field created in UIAlertController
        var textField = UITextField()
        
        //2. Create the UIAlertContoller popup with a placeholder
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //3. Create the action.  Code in following closure determines  what happens when the Add Item button in the UIAlert is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            /*  Saving Items
             Iteration 1 - (obsolete) - added an element to an array
             
             Iteration 2 - (obsolete) - Moved to MVC; initialize newItem from the Item class which was defined in Item.swift
             
             Iteration 3 - (obsolete) - Moved to CoreData.
             */
            
            /* Iteration 4 - Uses Realm */
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        //4. Add the text field to the alert: name the text field alertTextField
        alert.addTextField { (alertTextField) in
            // 4a. set up the text field's attributes
            alertTextField.placeholder = "Create new item"
            //4b. textfield can't be printed or added to the itemArray from here (since at this point we're just presenting the UIAlertController) but we can store whatever value the user types into the textField var which is accessible throughut the IBAction.
            textField = alertTextField
        }
        //5. Add the action which was created in steps 3 and 4 to the alert
        alert.addAction(action)
        
        //6. Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - Search bar methods

//// Create extension to extend the base VC
//extension ToDoListViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Create a request constant to fetch data from Item and return it as an array
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // Create query to constrain the fetch (cd means case and diacritic insensitive) and add query to request
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //Apply the sortdescriptors to the request
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        //Get data based on the above constraints
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    //Create delegate method which is triggered when content of the searchbar field changes, but specifically when length of searchbar text goes down to 0
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            // Call loadItems() with no parameter so that it runs the default request
//            loadItems()
//
//            // To get rid of onscreen keyboard at this point we force the searchbar to resign as first responder.  To do this, need to use DispatchQueue on the main thread
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
