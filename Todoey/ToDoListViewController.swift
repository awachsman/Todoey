//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //Create an array with 3 entries; these are todo items which will populate cells 1, 2 and 3 in the tableView
    let itemArray = ["Buy eggs", "Study Swift", "Go out to Dinner"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    // This function initially printed the selected array item when the item was clicked. Once this was demonstrated to work, print was commented out and instead, a checkmark accessory is invoked for the selected item Once selected, the row flashes gray briefly then reverts to nonselected look
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Print the selected array item (for test purposes)
        //print(itemArray[indexPath.row])
        
        // Check to see if seleted cell already has a checkmark accessory.  If it does, remove the checkmark.  If it doesn't add the checkmark accessory
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // Finally, revert to non-selected look for the cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
