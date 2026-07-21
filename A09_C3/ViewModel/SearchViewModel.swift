//
//  SearchViewModel.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 21/07/26.
//

import SwiftData
import Observation
import Foundation

@Observable
final class SearchViewModel {
    private let modelContext: ModelContext
    let historyStore: SearchHistoryStore
    
    var query: String = ""
    
    init(modelContext: ModelContext, historyStore: SearchHistoryStore = SearchHistoryStore()) {
        self.modelContext = modelContext
        self.historyStore = historyStore
    }
    
    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var hasQuery: Bool {
        !trimmedQuery.isEmpty
    }
    
    var groupedResults: [(category: SearchCategory, items: [SearchResultItem])] {
        guard hasQuery else { return [] }
        
        let obatResults = searchObat(matching: trimmedQuery)
        let pantauanResults = searchPantauan(matching: trimmedQuery)
        let konsulResults = searchKonsul(matching: trimmedQuery)
        
        return [
            (.obat, obatResults),
            (.pantauan, pantauanResults),
            (.konsultasi, konsulResults)
        ].filter { !$0.items.isEmpty }
    }
    
    var hasNoResults: Bool {
        hasQuery && groupedResults.isEmpty
    }
    
    func commitSearch() {
        historyStore.add(query: trimmedQuery)
    }
    
    func selectHistory(_ item: SearchHistoryItem) {
        query = item.query
    }
    
    // MARK: - Search implementations (pure filtering, testable via injected data)
    
    func searchObat(matching keyword: String) -> [SearchResultItem] {
        let all = (try? modelContext.fetch(FetchDescriptor<Obat>())) ?? []
        return all
            .filter { $0.nama.localizedCaseInsensitiveContains(keyword) }
            .map { obat in
                SearchResultItem(
                    category: .obat,
                    primaryText: obat.nama,
                    secondaryText: obat.keterangan.rawValue,
                    contextText: "\(obat.frekuensi) \(obat.dosis)",
                    destination: .obat(obat)
                )
            }
    }
    
    func searchPantauan(matching keyword: String) -> [SearchResultItem] {
        let all = (try? modelContext.fetch(FetchDescriptor<PantauanModel>())) ?? []
        return all
            .filter { $0.pantauanBody.localizedCaseInsensitiveContains(keyword) }
            .map { pantauan in
                SearchResultItem(
                    category: .pantauan,
                    primaryText: pantauan.pantauanDate.formatted(
                        .dateTime.day().month(.wide).year().locale(Locale(identifier: "id_ID"))
                    ),
                    secondaryText: pantauan.pantauanBody,
                    contextText: nil,
                    destination: .pantauan(pantauan)
                )
            }
    }
    
    func searchKonsul(matching keyword: String) -> [SearchResultItem] {
        let all = (try? modelContext.fetch(FetchDescriptor<KonsulModel>())) ?? []
        return all
            .filter {
                $0.namaDokter.localizedCaseInsensitiveContains(keyword) ||
                $0.content.localizedCaseInsensitiveContains(keyword)
            }
            .map { konsul in
                SearchResultItem(
                    category: .konsultasi,
                    primaryText: konsul.namaDokter,
                    secondaryText: konsul.content,
                    contextText: konsul.tanggalKonsultasi.formatted(
                        .dateTime.day().month().year().locale(Locale(identifier: "id_ID"))
                    ),
                    destination: .konsul(konsul)
                )
            }
    }
}
