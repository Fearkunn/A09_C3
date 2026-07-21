//
//  SearchHistoryItem.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 21/07/26.
//

import Foundation

struct SearchHistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let query: String
    let searchedAt: Date

    init(query: String, searchedAt: Date = .now) {
        self.id = UUID()
        self.query = query
        self.searchedAt = searchedAt
    }
}
