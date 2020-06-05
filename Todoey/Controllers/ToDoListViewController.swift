//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
/*
 1. Changed class definition so that inheritance is from SwipeTableViewController instead of UITableViewController
 2. Comment out let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) and replace with let cell = super.tableView(tableView, cellForRowAt: indexPath)
 
 */
import UIKit
import RealmSwift

// The ToDoListViewController is the delegate for the UISearchBar
class ToDoListViewController: SwipeTableViewController {
    /* Iteration 1 - (obsolete) - Create array with todo items which populate tableView cells.
     
     Iteration 2 - (obsolete) -
     Under MVC, array is driven by Item class initialized in Item.swift
     
     Iteration 3
     With Core Data and creation of CatgoryVC, itemArray is filtered to selected category. This happens in the prepare(for segue:... method in TableView Delegate Methods
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
        /* Iteration 1 (obsolete) - Items saved in a defaults file  which loads the tableview as follows:
         if let items = defaults.array(forKey: "TodoListArray") as? [String] {
             itemArray = items
         }
         Iteration 2 - (obsolete) - Under MVC, items are initialized based on Item class, defined in Item.swift.  addButtonPressed contains  "self. defaults. set(self.itemArray, forKey: "TodoListArray")", saving array to the user defaults named "defaults".
        */
        
        /* Iteration 3 - Originally, we called loadItems() at this point to load items using CoreData. Note -[no param passed to loadItems() since default param of Item. fetchRequest is specified in the function definition].  We now call loadItems() to match selected category in didSet method when we declared the var selectedCategory
         
         loadItems()
         */
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Obsolete - Now using superclass's cell definition named "Cell"
         let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)*/
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        /*
        Create constant "item",set its value to todoItems?[indexPath].row.  This allows us to use that constant wherever itemArray[indexPath].row is called in this function
        */
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items Added."

        }
        
        return cell
    }
    
    ///MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                    
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            //tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate Methods
    // Under Realm, data updating or deleting takes place in function below
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // The code below changes selected item's done status and saves  change to Realm; commented line shows how an item can be deleted
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving item's done status, \(error)")
            }
        }

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //NOTE:  Understanding of scope for variables is necessary to follow sequence of events below.  6 steps are:
        
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
                        newItem.dateCreated = Date()
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
            //4b. textfield can't be printed from here (since at this point we're just presenting the UIAlertController) but we can store whatever value the user types into the textField var which is accessible throughut the IBAction.
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
/* Iteration 1 - obsolete - ToDoListVC extension was designed for CoreData. The extension has been rewritten for Realm */

/* Iteration 2 - using Realm for querying */
// Create extension to extend the base VC
extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Use searchbar content to filter and sort our ToDoList items   
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    //Create delegate method; is triggered when searchbar field's content changes, including when length of searchbar text goes down to 0
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        // Call loadItems() with no param so that it runs the default request
            loadItems()

        // Get rid of onscreen keyboard at this point by forcing searchbar to resign as first responder.  To do this, need to use DispatchQueue on the main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
