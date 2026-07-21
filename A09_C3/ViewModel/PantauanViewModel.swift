//
//  PantauanViewModel.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 18/07/26.
//

import SwiftData
import Observation
import Foundation

@Observable
final class PantauanViewModel {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func add(date: Date, body: String) throws {
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let pantauan = PantauanModel(
            pantauanDate: date,
            pantauanBody: trimmedBody
        )
        modelContext.insert(pantauan)
        try modelContext.save()
    }
    
    func update(_ pantauan: PantauanModel, date: Date, body: String) throws {
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
        
        pantauan.pantauanDate = date
        pantauan.pantauanBody = trimmedBody
        pantauan.pantauanUpdatedAt = .now
        
        try modelContext.save()
    }
    
    func delete(_ pantauan: PantauanModel) {
        modelContext.delete(pantauan)
        try? modelContext.save()
    }
    
    func fetchAll() -> [PantauanModel] {
        let descriptor = FetchDescriptor<PantauanModel>(
            sortBy: [SortDescriptor(\.pantauanDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
