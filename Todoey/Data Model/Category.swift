//
//  Category.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""  // keyword "dynamic" allows us to monitor for changes while app is running
    
    // Define the forward relationship between Category and Item as a List of item objects which will initially be empty
    let items = List<Item>()
}
