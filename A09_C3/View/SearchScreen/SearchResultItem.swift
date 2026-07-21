//
//  SearchResultItem.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 21/07/26.
//

import Foundation

struct SearchResultItem: Identifiable {
    let id = UUID()
    let category: SearchCategory
    let primaryText: String
    let secondaryText: String
    let contextText: String?
    let destination: SearchDestination
}

enum SearchCategory: String, CaseIterable {
    case obat = "Obat"
    case pantauan = "Pantauan"
    case konsultasi = "Konsultasi"
}

enum SearchDestination {
    case obat(Obat)
    case pantauan(PantauanModel)
    case konsul(KonsulModel)
}
