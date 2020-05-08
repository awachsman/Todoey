//
//  Item.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//This was changed when we moved to an NSCoder approach instead of user defaults.  The enoder approach required that the Item class be encodable, which is what is shown here
class Item: Encodable {
    var title: String = ""
    var done: Bool = false
}
