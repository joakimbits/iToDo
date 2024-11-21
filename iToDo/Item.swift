//
//  Item.swift
//  iToDo
//
//  Created by Joakim Pettersson on 2024-11-21.
//

import Foundation
import SwiftData

@Model
class Item: Identifiable {
    var title: String
    var isDone: Bool
    var createdAt: Date
    
    init(title: String, isDone: Bool = false, createdAt: Date = Date()) {
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
    }
}
