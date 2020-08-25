//
//  Item.swift
//  Todo
//
//  Created by Harrison Gittos on 25/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = "";
    @objc dynamic var done: Bool = false;
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items");
}
