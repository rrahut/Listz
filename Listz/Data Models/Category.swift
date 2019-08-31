//
//  Category.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/26/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
