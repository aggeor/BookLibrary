//
//  Item.swift
//  BookLibrary
//
//  Created by Aggelos Georgiadis on 29/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
