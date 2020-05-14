//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

// The ToDoListViewController is the delegate for the UISearchBar
class ToDoListViewController: UITableViewController {
    /* Iteration 1 - (obsolete) -
     Initially, an array with 3 todo items was created which served to populate cells 1, 2 and 3 in the tableView.
     
     var itemArray = ["Buy eggs", "Study Swift", "Go out to Dinner"]
     
     However, this has been commented out as we moved to MVC design in Iteration 2.
    
     Iteration 2 - (obsolete) -
     
     *Using MVC, use an array based on the Item class initialized in Item.swift
     */
    
    var itemArray = [Item]()
    
    //Convert the AppDelegate class to an object in order to get at .persistentContainer; assign the result to a constant called context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /* Iteration 1 - (obsolete) -
      We started with user defaults but after moving to MVC, determined that defaults could not save non-standard datatypes created from the Item.swift file. Therefore, that code, which created a "defaults" constant based on UserDefaults.standard, is commented out below
     
     // Ceate a standard user defaults database
     let defaults = UserDefaults.standard
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // History -
        /* Iteration 1 (obsolete) - Items are saved in a user defaults file named "defaults". "defaults" loads the tableview as follows:
         if let items = defaults.array(forKey: "TodoListArray") as? [String] {
             itemArray = items
         }
         Iteration 2 - (obsolete) - Code above was obsoleted once we applied MVC.  Items are now initialized based on class named Item, as defined in Item.swift.  The IBAction addButtonPressed contains  "self.defaults.set(self.itemArray, forKey: "TodoListArray")" which saves the array in the user defaults named "defaults".
         // This code substitutes for code in Iteration 1 and reflects MVC
        */
        
        
        /* The harcoded items below are no longer required since we now load the itemArray with records from the plist in dataFilePath
         
        let newItem = Item()
        newItem.title = "Buy eggs"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Study swift"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go out to dinner"
        itemArray.append(newItem3)
        */
        
        /*
         Call loadItems() to load items from SQLite using CoreData. Note - no param provided to loadItems() below since a default param of Item.fetchRequest has been specified in the function's  definition
         */
        
        loadItems()
        
        /* Iteration 1 - obsolete -used user defaults in a file named "defaults".  That has been obsoleted since defaults can't accept a complex data type like Items (as created in the Item class in Item.swift.  That has been changed to an NSCoder type.
         
         if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
         }
         */
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        /*
        Create constant named item; set its value to itemArray[indexPath].row.  This allows us to use that constant wherever itemArray[indexPath].row is called in this function
        */
        let item = itemArray[indexPath.row]
        
        /*
         There are several ways to turn the checkmark on and off
         Method 1: (obsolete) - This was the original method before we defined the constant called item.  Instead it used "itemArray[indexPath.row" and then used an if-else to set the accessoryType to .checkmark or  to .none
         
         cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true {
           cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
         
        Method 2: (obsolete) - identical to Method 1 but uses the constant called item
         
        cell.textLabel?.text = item.title
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        Method 3: still uses item but replaces  if-else with a ternary operator.

         In general,
         Ternary operator ==>
         value = comdition ? valueIfTrue : valueIfFalse

         In the code below, the ternary operator is read as follows:
         Set the cell.accessoryType depending on whether the item.done is true.  If it is, set it to .checkmark, otherwise, set it to .none
         */
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    // This function initially printed the selected array item when the item was clicked. Once this was demonstrated to work, print was commented out and instead, a checkmark accessory is invoked for the selected item. The selected row flashes gray briefly then reverts to nonselected look
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* We denote item completion by displaying a checkmark to the right of the selected item
         
         This was originally donw with the following:
         
         Iteration 1: (obsolete) -
         
         if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
            } else {
            itemArray[indexPath.row].done = false
          }
         
         Above code is verbose and has been replaced by Iteration 2, which examines the done property, toggles status to the opposite of what it currently is and writes array to the file
         */
        
        /*
         This code segment changes app behavior.  It serves to delete records instead of adding or removing the checkmark accessory. Procedurally, one must remove the item from CoreData before removing it from itemArray since otherwise, indexPath.row may have an inaccurate value.
         
         Remove from CoreData:
         context.delete(itemArray[indexPath.row])
         
         Remove from the array:
         itemArray.remove(at: indexPath.row)
         */
        
        
        //Iteration 2
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        //tableView.reloadData()  // This now exists in saveItems()
        
        // Comment/code below commented out, since we've moved to MVC, and the completed/non-completed status of an item is now handled by Item.swift in the Data model folder
        
        // If seleted cell already has a checkmark, remove it, otherwise add it
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        // Finally, revert to non-selected look for the cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //NOTE:  Understanding of scope for variables is necessary to follow sequence of events below.  6                        steps are:
        
        //1. Initialize avar called textField which is accessible throughout this IBAction and holds whatever is placed into the text field we're creating in the UIAlertController
        var textField = UITextField()
        
        //2. Create the UIAlertContoller popup with a placeholder
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //3. Create the action.  Code in following closure determines  what happens when the Add Item button in the UIAlert is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            /*
             Different methods used to create an element called newItem
             Iteration 1 - (obsolete) - add an element to an array
             
             self.itemArray.append(textField.text!)
             
             Iteration 2 - (obsolete) - Move to MVC; initialize newItem from the Item class which was defined in Item.swift
             
             let newItem = Item()
             
             Iteration 3 - Move to CoreData.  See below
             */
            
            /*Iteration 3 begins here. Set newItem to the viewContext of our persistent container as specified in AppDelegate.swift.
             Also note that since the done field in DataModel.xcdatamodeld is not optional, we need to provide a value for the done field
             */
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            /*
             Iteration 1 (obsolete) -
             First we used user defaults and created a "defaults" object to store an itemArray.  We're now storing array information in a documents folder on the phone.  The obsoleted code follows below.
             
             // Add element to userdefaults.  TodoListArray identifies the array within the defaults.  CAUTION: default is updated with latest array information in a plist but defaults must be explicitly read from in order to populate the tableView with saved data
             
             self.defaults.set(self.itemArray, forKey: "TodoListArray")
             
             In place of the above, Iteration 2 uses an encoder as shown in the saveItems() function, called below
             */
            
            self.saveItems()
            
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
    
    func saveItems() {
        
        /* Iteration 2 (obsolete) - Using dataFilePath, encode itemArray data and write it to path
         
         Create an encoder, initialize it and use it to encode itemArray
         
         let encoder = PropertyListEncoder()
         
         do {
             let data = try encoder.encode(itemArray)
             try  data.write(to: dataFilePath!)
         } catch {
             print("Error encoding item array, \(error)")
         }
         
         */
    
        /* Iteration 3, using CoreData
         
         */
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        // refresh the tableView to display added item
        self.tableView.reloadData()
    }
    
    // The following function loads items into itemArray and returns it; note use of "with" as external param and "request" as internal param.  Also note that in the event no param is passed, a default value to param is passed; this param is Item.fetchRequest()
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        /* Iteration 2 - (obaolete) Using dataFilePath URL, create constant named data; set it to Data
        
         if let data = try? Data(contentsOf: dataFilePath!) {
             // Create a decoder, initialize it and use it to encode itemArray
             let decoder = PropertyListDecoder()
             do {
                 itemArray =  try decoder.decode([Item].self, from: data)
             } catch {
                 print("Error decoding item array, \(error)")
             }
         }
        */
        
        /* Iteration 3 moves to CoreData and begins below
         (obsolete) - Originlly, we created a constant named request, of type NSFetchRequest.  In doing so, the datatype MUST be specified and you MUST also specify the entity that you're trying to request.  However, line below is no longer required since the loadItems function now takes request as a param
         
         let request : NSFetchRequest<Item> = Item.fetchRequest()
         
         */
        
        // App must speak to the context.  Since this can throw an error, need to encapsulate in a do/try/catch.  Assign the results of the context.fetchrequest to itemArray
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

// Create extension to extend the base VC
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Create a request constant which fetches data from Item and returns it as an array
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Create query to constrain the fetch (cd means case and diacritic insensitive) and add query to request
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort the returned data and apply the sortdescriptors to the request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //Get data based on the above constraints
        loadItems(with: request)
        
    }
}


