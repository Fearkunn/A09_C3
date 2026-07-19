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
struct AddKonsulViewModelTests {
    
    private let container: ModelContainer
    private let context: ModelContext
    private let vm: AddKonsulViewModel
    
    init() throws {
        let schema = Schema([KonsulModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        context = ModelContext(container)
        vm = AddKonsulViewModel()
    }
    @Test("Berhasil membuat konsultasi jika semua field valid")
    func createKonsultasi_berhasil() throws {
        let vm = AddKonsulViewModel()
        vm.namaDokter = "dr. Lala"
        vm.content = "Sakit kepala 3 hari"
        
        let result = vm.addKonsultasi(context: context)
        
        #expect(result == true)
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.count == 1)
        #expect(all.first?.namaDokter == "dr. Lala")
        #expect(all.first?.content == "Sakit kepala 3 hari")
    }
    
    @Test("Tidak berhasil membuat konsultasi jika ada field yang tidak terisi")
    func createKonsultasi_gagal() throws {
        let vm = AddKonsulViewModel()
        vm.namaDokter = "dr. Lala"
        
        let result = vm.addKonsultasi(context: context)
        
        #expect(result == false)
        
        let all = try context.fetch(FetchDescriptor<KonsulModel>())
        #expect(all.isEmpty)
    }
    
}
