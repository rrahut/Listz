//
//  Item.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/26/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
