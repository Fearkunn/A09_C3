//
//  PantauanViewModelTests.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 18/07/26.
//

import Testing
import SwiftData
import Foundation
@testable import A09_C3

@MainActor
struct PantauanViewModelTests {
    
    private let container: ModelContainer
    private let context: ModelContext
    private let sut: PantauanViewModel
    
    init() throws {
        let schema = Schema([PantauanModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        context = container.mainContext
        sut = PantauanViewModel(modelContext: context)
    }
    
    // MARK: - ADD
    
    @Test("Menambah pantauan baru berhasil tersimpan ke context")
    func addPantauan_insertsNewRecord() throws {
        try sut.add(date: Date(), body: "Sakit tenggorokan, batuk-batuk")
        
        let all = try context.fetch(FetchDescriptor<PantauanModel>())
        #expect(all.count == 1)
    }
    
    @Test("Field tanggal dan body tersimpan sesuai input")
    func addPantauan_setsCorrectDateAndBody() throws {
        let tanggal = Date(timeIntervalSince1970: 1_712_000_000)
        
        try sut.add(date: tanggal, body: "Sakit tenggorokan, batuk-batuk")
        
        let all = try context.fetch(FetchDescriptor<PantauanModel>())
        #expect(all.first?.pantauanDate == tanggal)
        #expect(all.first?.pantauanBody == "Sakit tenggorokan, batuk-batuk")
    }
    
    @Test("Spasi berlebih di awal/akhir body dihapus otomatis saat disimpan")
    func addPantauan_trimsWhitespaceFromBody() throws {
        try sut.add(date: Date(), body: "   Demam tinggi   ")
        
        let all = try context.fetch(FetchDescriptor<PantauanModel>())
        #expect(all.first?.pantauanBody == "Demam tinggi")
    }
    
    // MARK: - EDIT / UPDATE
    
    @Test("Update mengubah body dan tanggal pantauan yang sudah ada")
    func updatePantauan_changesBodyAndDate() throws {
        try sut.add(date: Date(), body: "Sakit tenggorokan")
        
        let existing = try #require(try context.fetch(FetchDescriptor<PantauanModel>()).first)
        let tanggalBaru = Date().addingTimeInterval(86_400)
        
        try sut.update(existing, date: tanggalBaru, body: "Sakit tenggorokan, batuk batuk")
        
        #expect(existing.pantauanBody == "Sakit tenggorokan, batuk batuk")
        #expect(existing.pantauanDate == tanggalBaru)
    }
    
    @Test("Update tidak menambah record baru, cuma mengubah yang sudah ada")
    func updatePantauan_doesNotCreateNewRecord() throws {
        try sut.add(date: Date(), body: "Sakit tenggorokan")
        let existing = try #require(try context.fetch(FetchDescriptor<PantauanModel>()).first)
        
        try sut.update(existing, date: Date(), body: "Demam")
        
        let all = try context.fetch(FetchDescriptor<PantauanModel>())
        #expect(all.count == 1)
    }
    
    @Test("Update mengisi pantauanUpdatedAt dengan waktu baru")
    func updatePantauan_setsUpdatedAtTimestamp() throws {
        try sut.add(date: Date(), body: "Sakit tenggorokan")
        let existing = try #require(try context.fetch(FetchDescriptor<PantauanModel>()).first)
        #expect(existing.pantauanUpdatedAt == nil)
        
        try sut.update(existing, date: Date(), body: "Demam")
        
        #expect(existing.pantauanUpdatedAt != nil)
    }
    
    
    // MARK: - DELETE
    
    @Test("Delete menghapus record yang tepat dari context")
    func deletePantauan_removesRecordFromContext() throws {
        try sut.add(date: Date(), body: "Sakit tenggorokan")
        let target = try #require(try context.fetch(FetchDescriptor<PantauanModel>()).first)
        
        sut.delete(target)
        
        let all = try context.fetch(FetchDescriptor<PantauanModel>())
        #expect(all.isEmpty)
    }
    
    @Test("Delete hanya menghapus 1 record yang dipilih, sisanya tetap ada")
    func deletePantauan_onlyRemovesTargetRecord() throws {
        try sut.add(date: Date(), body: "Sakit tenggorokan")
        try sut.add(date: Date(), body: "Demam tinggi")
        
        let all = try context.fetch(FetchDescriptor<PantauanModel>())
        let target = try #require(all.first { $0.pantauanBody == "Sakit tenggorokan" })
        
        sut.delete(target)
        
        let remaining = try context.fetch(FetchDescriptor<PantauanModel>())
        #expect(remaining.count == 1)
        #expect(remaining.first?.pantauanBody == "Demam tinggi")
    }
    
    // MARK: - FETCH / LIST
    
    @Test("fetchAll mengembalikan array kosong saat belum ada data (empty state)")
    func fetchAll_returnsEmptyArray_whenNoData() throws {
        #expect(sut.fetchAll().isEmpty)
    }
    
    @Test("fetchAll mengembalikan data terurut dari yang terbaru")
    func fetchAll_returnsSortedByDateDescending() throws {
        let tanggalLama = Date().addingTimeInterval(-86_400 * 5)
        let tanggalBaru = Date()
        
        try sut.add(date: tanggalLama, body: "Catatan lama")
        try sut.add(date: tanggalBaru, body: "Catatan baru")
        
        let result = sut.fetchAll()
        
        #expect(result.first?.pantauanBody == "Catatan baru")
        #expect(result.last?.pantauanBody == "Catatan lama")
    }
    
    @Test("fetchAll mengembalikan semua record sesuai jumlah yang ditambahkan")
    func fetchAll_returnsCorrectCount() throws {
        try sut.add(date: Date(), body: "Catatan 1")
        try sut.add(date: Date(), body: "Catatan 2")
        try sut.add(date: Date(), body: "Catatan 3")
        
        #expect(sut.fetchAll().count == 3)
    }
}
