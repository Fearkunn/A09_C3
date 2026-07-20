//
//  KonsulTesting.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import Testing
import Foundation
import SwiftData
@testable import A09_C3

@Suite("AddKonsul ViewModel Test")
struct KonsultasiViewModelTests {
    
    private let container: ModelContainer
    private let context: ModelContext
    private let vm: KonsultasiViewModel
    
    init() throws {
        let schema = Schema([KonsulModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        context = ModelContext(container)
        vm = KonsultasiViewModel(modelContext: context)
    }
    @Test("Berhasil membuat konsultasi jika semua field valid")
    func createKonsultasi_berhasil() throws {
        try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "Sakit kepala 3 hari")
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.count == 1)
        #expect(all.first?.namaDokter == "dr. Lala")
        #expect(all.first?.content == "Sakit kepala 3 hari")
    }
    
    @Test("Field tanggal tersimpan sesuai input")
    func addKonsultasi_setsCorrectDate() throws {
        let tanggal = Date(timeIntervalSince1970: 1_712_000_000)
        
        try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: tanggal, content: "Sakit kepala 3 hari")
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.first?.tanggalKonsultasi == tanggal)
    }
    
    
    @Test("Menyimpan dengan namaDokter kosong menghasilkan error validasi, bukan disimpan")
    func addKonsultasi_withEmptyNamaDokter_throwsValidationError() throws {
        #expect(throws: KonsultasiValidationError.emptyDokter) {
            try vm.addKonsultasi(namaDokter: "", tanggal: Date(), content: "Sakit kepala")
        }
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.isEmpty)
    }
    
    @Test("Menyimpan dengan content kosong menghasilkan error validasi, bukan disimpan")
    func addKonsultasi_withEmptyContent_throwsValidationError() throws {
        #expect(throws: KonsultasiValidationError.emptyBody) {
            try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "")
        }
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.isEmpty)
    }
    
    @Test("namaDokter isi spasi saja (tanpa teks) tetap dianggap kosong")
    func addKonsultasi_withWhitespaceOnlyNamaDokter_throwsValidationError() throws {
        #expect(throws: KonsultasiValidationError.emptyDokter) {
            try vm.addKonsultasi(namaDokter: "   ", tanggal: Date(), content: "Sakit kepala")
        }
    }
    
    @Test("content isi spasi saja (tanpa teks) tetap dianggap kosong")
    func addKonsultasi_withWhitespaceOnlyContent_throwsValidationError() throws {
        #expect(throws: KonsultasiValidationError.emptyBody) {
            try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "     ")
        }
    }
    
    
    @Test("Update mengubah namaDokter, tanggal, dan content yang sudah ada")
    func updateKonsultasi_changesFields() throws {
        try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "Sakit kepala")
        let existing = try #require(try context.fetch(FetchDescriptor<KonsulModel>()).first)
        let tanggalBaru = Date().addingTimeInterval(86_400)
        
        try vm.update(existing, namaDokter: "dr. Budi", tanggal: tanggalBaru, content: "Demam tinggi")
        
        #expect(existing.namaDokter == "dr. Budi")
        #expect(existing.content == "Demam tinggi")
        #expect(existing.tanggalKonsultasi == tanggalBaru)
    }
    
    @Test("Update tidak menambah record baru, cuma mengubah yang sudah ada")
    func updateKonsultasi_doesNotCreateNewRecord() throws {
        try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "Sakit kepala")
        let existing = try #require(try context.fetch(FetchDescriptor<KonsulModel>()).first)
        
        try vm.update(existing, namaDokter: "dr. Lala", tanggal: Date(), content: "Demam tinggi")
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.count == 1)
    }
    
    @Test("Update dengan content kosong ditolak, data lama tidak berubah")
    func updateKonsultasi_withEmptyContent_throwsAndKeepsOldData() throws {
        try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "Sakit kepala")
        let existing = try #require(try context.fetch(FetchDescriptor<KonsulModel>()).first)
        
        #expect(throws: KonsultasiValidationError.emptyBody) {
            try vm.update(existing, namaDokter: "dr. Lala", tanggal: Date(), content: "")
        }
        #expect(existing.content == "Sakit kepala")
    }
    
    @Test("Update dengan namaDokter kosong ditolak, data lama tidak berubah")
    func updateKonsultasi_withEmptyNamaDokter_throwsAndKeepsOldData() throws {
        try vm.addKonsultasi(namaDokter: "dr. Lala", tanggal: Date(), content: "Sakit kepala")
        let existing = try #require(try context.fetch(FetchDescriptor<KonsulModel>()).first)
        
        #expect(throws: KonsultasiValidationError.emptyDokter) {
            try vm.update(existing, namaDokter: "", tanggal: Date(), content: "Sakit kepala")
        }
        #expect(existing.namaDokter == "dr. Lala")
    }
}
