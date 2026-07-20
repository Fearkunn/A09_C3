//
//  KonsultasiViewModel.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import Foundation
import SwiftData

enum KonsultasiValidationError: Error {
    case emptyDokter
    case emptyBody
}

class KonsultasiViewModel {
    private let modelContext: ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addKonsultasi(namaDokter: String, tanggal: Date, content: String) throws {
        guard !namaDokter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw KonsultasiValidationError.emptyDokter
        }
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw KonsultasiValidationError.emptyBody
        }
        
        let konsultasi = KonsulModel(
            namaDokter: namaDokter,
            tanggalKonsultasi: tanggal,
            content: content
        )
        modelContext.insert(konsultasi)
    }
    func update(_ konsultasi: KonsulModel, namaDokter: String, tanggal: Date, content: String) throws {
        guard !namaDokter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw KonsultasiValidationError.emptyDokter
        }
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw KonsultasiValidationError.emptyBody
        }
        
        konsultasi.namaDokter = namaDokter
        konsultasi.tanggalKonsultasi = tanggal
        konsultasi.content = content
    }
    
    func fetchAll() -> [PantauanModel] {
        let descriptor = FetchDescriptor<PantauanModel>(
            sortBy: [SortDescriptor(\.pantauanDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func delete(_ pantauan: PantauanModel) {
        modelContext.delete(pantauan)
        try? modelContext.save()
    }
}
