//
//  SearchHistoryStore.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 21/07/26.
//

import Foundation

@Observable
final class SearchHistoryStore {
    private let storageKey = "search_history"
    private let maxItems = 10
    private let defaults: UserDefaults

    private(set) var items: [SearchHistoryItem] = []

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func add(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        items.removeAll { $0.query.caseInsensitiveCompare(trimmed) == .orderedSame }
        items.insert(SearchHistoryItem(query: trimmed), at: 0)

        if items.count > maxItems {
            items = Array(items.prefix(maxItems))
        }

        persist()
    }

    func remove(_ item: SearchHistoryItem) {
        items.removeAll { $0.id == item.id }
        persist()
    }

    func clearAll() {
        items = []
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) else { return }
        items = decoded
    }
}
