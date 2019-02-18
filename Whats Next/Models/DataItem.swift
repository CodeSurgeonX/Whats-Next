//
//  DataItem.swift
//  Whats Next
//
//  Created by Shashwat  on 18/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation
import RealmSwift

class DataItem : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
