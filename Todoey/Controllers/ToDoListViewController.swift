//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    /* Iteration 1
     Initially, an array with 3 todo items was created which served to populate cells 1, 2 and 3 in the tableView.
     
     var itemArray = ["Buy eggs", "Study Swift", "Go out to Dinner"]
     
     However, this has been commented out as we moved to MVC design in Iteration 2.
     */
    
    
    /* Iteration 2
     Using MVC, use an array based on the Item class initialized in Item.swift
     */
    
    var itemArray = [Item]()
    
    /* Create a constant to hold the file path to a default url path for shared files (that default is a singleton), in the user's personal directory.  This is an array, and we want to grab the first item.  In that first item, we'll create Items.plist.  In total, this is a path where we will create the documents we want to save
     */
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    /* Iteration 1
      We started with user defaults but after moving to MVC, determined that defaults could not save non-standard datatypes created from the Item.swift file. Therefore, that code, which created a "defaults" constant based on UserDefaults.standard, is commented out below
     
     // Ceate a standard user defaults database
     let defaults = UserDefaults.standard
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // History -
        /* Iteration 1 - Items are saved in a user defaults file named "defaults". "defaults" loads the tableview as follows:
         if let items = defaults.array(forKey: "TodoListArray") as? [String] {
             itemArray = items
         }
         Iteration 2 - Code above was obsoleted once we applied MVC.  Items are now initialized based on class named Item, as defined in Item.swift.  The IBAction addButtonPressed contains  "self.defaults.set(self.itemArray, forKey: "TodoListArray")" which saves the array in the user defaults named "defaults".
         // This code substitutes for code in Iteration 1 and reflects MVC
        */
        
        print(dataFilePath)
        
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
        // Call loadItems() to load data from plist located in dataFilePath
        
        loadItems()
        
        // Iteration 1 - used user defaults in a file named "defaults".  That has been obsoleted since defaults can't accept a complex data type like Items (as created in the Item class in Item.swift.  That has been changed to an NSCoder type
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
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
         Method 1: This was the original method before we defined the constant called item.  Instead it used "itemArray[indexPath.row" and then used an if-else to set the accessoryType to .checkmark or  to .none
         
         cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true {
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
        
        // This code look at the done property, changes status to the opposite of what it currently is and writes array to the file
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
        //NOTE:  Understanding of scope for variables is necessary to follow sequence of events below
        //1. Initialize an empty text field called textField.  It's accessible throughout this IBAction and holds whatever is placed into the text field we're creating in the UIAlertController
        var textField = UITextField()
        
        //2. Create the UIAlertContoller popup with a placeholder
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //3. Create the action.  Code in following closure determines  what happens when the Add Item button in the UIAlert is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //NOTE : Moving to MVC replaces the line below with the code after the line below to add an item to the itemArray
            //self.itemArray.append(textField.text!) //texfield.text was created in 4b. below.
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            /*
             Iteration 1 -
             Initially, we used user defaults and created a "defaults" object to store an itemArray.  We're now storing array information in a documents folder on the phone.  The obsoleted code follows below.
             
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
        
        //Iteration 2 -
        
        // Create an encode and initialize it
        let encoder = PropertyListEncoder()
        
        // Encode our itemArray
        
        do {
            let data = try encoder.encode(itemArray)
            try  data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        // refresh the tableView to display added item
        self.tableView.reloadData()
    }
    
    func loadItems() {
        // Create a constant named data and set it to Data created using the contents of a URL
        if let data = try? Data(contentsOf: dataFilePath!) {
            // Create a decoder
            let decoder = PropertyListDecoder()
            do {
                itemArray =  try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}


