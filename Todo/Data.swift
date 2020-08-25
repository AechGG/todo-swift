//
//  Data.swift
//  Todo
//
//  Created by Harrison Gittos on 25/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = "";
    @objc dynamic var age: Int = 0;
}
