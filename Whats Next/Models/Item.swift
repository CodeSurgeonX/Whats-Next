//
//  Item.swift
//  Whats Next
//
//  Created by Shashwat  on 18/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    var parentCategory = LinkingObjects(fromType: categoryItem.self, property: "items")
}
