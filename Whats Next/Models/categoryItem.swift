//
//  categoryItem.swift
//  Whats Next
//
//  Created by Shashwat  on 18/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation
import RealmSwift

class categoryItem : Object {
    @objc dynamic var name : String = ""
    var items = List<Item>()   // Very much similiar to -> let arrayItems = Array<Int>()
}
