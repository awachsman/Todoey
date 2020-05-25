//
//  Item.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // Define the inverse relationship between Item and Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
