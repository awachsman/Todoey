//
//  Item.swift
//  Todoey
//
//  Created by Abraham Wachsman on 5/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//This was changed when we moved to an NSCoder approach instead of user defaults.  The enoder approach required that the Item class be both encodable and decodable; to designate both, Codable is used here
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
