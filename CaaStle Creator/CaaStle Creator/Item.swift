//
//  Item.swift
//  CaaStle Creator
//
//  Created by Prajwal Nayaka on 28/10/23.
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
