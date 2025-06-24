//
//  Item.swift
//  PokeExplorer
//
//  Created by user277150 on 6/20/25.
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
