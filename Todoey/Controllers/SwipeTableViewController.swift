//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Abraham Wachsman on 6/2/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0


    }
    
    //MARK: - TableView Datasource Methods
    
    // Note - this replaces the prior code which specifically referred to cell as CategoryCell - the intent is to make the code generic so that it can handle cells from either catgegories or items
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self

        
        return cell
    }
    
    // This code initially resided as an extension in CategoryViewController but has been moved here since this is the superclass for both the CategoryViewController as well as the TodoListViewController.  The delete category method is commented out because it's specific and is not something that should be inherited by other ViewController's
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            print("Delete cell")

        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath)  {
        // Update our data model. Note that this gets overidden in CategoryVC (and in ToDoList VC?)
    }

}

