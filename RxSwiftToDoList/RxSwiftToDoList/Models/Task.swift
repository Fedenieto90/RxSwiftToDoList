//
//  Task.swift
//  RxSwiftToDoList
//
//  Created by Federico Nieto on 30/05/2019.
//  Copyright © 2019 Federico Nieto. All rights reserved.
//

import UIKit

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    var title: String
    var priority: Priority
}
