//
//  Item.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 14/07/26.
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
