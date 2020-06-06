//
//  TodoItem.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 01.04.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import Foundation
import SwiftUI

// Model
// Our data stores as such structures.
struct TodoItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
    var colorName: String = "teal"
}
