//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //Initially, an array with 3 todo items was created which served to populate cells 1, 2 and 3 in the tableView
    
    //However, this has been coommented out as we moved to MVC design.
    //var itemArray = ["Buy eggs", "Study Swift", "Go out to Dinner"]
    
    // In place of the above, we have an array based on the Item class initialized in Item.swift
    var itemArray = [Item]()
    
    // Ceate a standard user defaults database
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment and code below are commented out as we applied MVC.  Items are now initialized based on class named Item, as defined in Item.swift
        // IBAction addButtonPressed contains  "self.defaults.set(self.itemArray, forKey: "TodoListArray")" which saves the array in the user defaults named "defaults".  defaults loads the tableview as follows:
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
        // This code substitutes for code above and reflects MVC
        let newItem = Item()
        newItem.title = "Buy eggs"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Study swift"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go out to dinner"
        itemArray.append(newItem3)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        /*
        Create a constant named item and set its value to itemArray[indexPath].row.  Doing this allows us to use that constant wherever itemArray[indexPath].row is called in this function
        */
        let item = itemArray[indexPath.row]
        
        /*
         There are several ways to turn the checkmark on and off
         Method 1: Method 1 was the original method before we defined the constant called item.  Instead it used "itemArray[indexPath.row" and then used an if-else to set the accessoryType to .checkmark or  to .none
         
         cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true {/
           cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
         
        Method 2: identical to Method 1 but uses the constant called item
         
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
        
        
        // The code below was a first approximation at setting the value of the done property defined in the the class named Item (oused in Item.swift).  However, it is wordy and inelegant and is now commented out.  The code which follows it now handles setting the value of the done property.
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        // This code look at the done property and changes status to the opposite of what it currently is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // Comment and code below are commented out, since we've moved to MVC, and the completed or non-completed status of an item is now handled by Item.swift in the Data model folder
        // If seleted cell already has a checkmark accessory, remove it, otherwiseadd it
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
        //NOTE:  Understanding of scope for variables is necessary to follow sequence of events below
        //1. Initialize an empty text field called textField.  It is accessible throughout this IBAction and will hold whatever is placed into the text field we're creating in the UIAlertController
        var textField = UITextField()
        
        //2. Create the UIAlertContoller popup with a placeholder
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //3. Create the action.  Code in following closure determines  what happens when the Add Item button in the UIAlert is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //NOTE : Moving to MVC requires the line below to chenge.  The code after the line below is now what adds an item to the itemArray
            //self.itemArray.append(textField.text!) //texfield.text was created in 4b. below.
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // Add element to userdefaults.  The keyword TodoListArray identifies the array within the defaults.  CAUTION: default is updated with latest array information in a plist but defaults must be explicitly read from in order to populate the tableView with saved data
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // refresh the tableView to display added item
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
    
}


