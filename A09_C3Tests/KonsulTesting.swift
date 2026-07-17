//
//  KonsulTesting.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import Testing
import Foundation

@testable import A09_C3

@Suite("AddKonsul ViewModel Test")
struct AddKonsulViewModelTests {
    
    @Test("Berhasil membuat konsultasi jika semua field valid")
    func createKonsultasi_berhasil() throws {
        let vm = AddKonsulViewModel()
        vm.namaDokter = "dr. Andi"
        vm.content = "Sakit kepala 3 hari"
        
        let result = vm.addKonsultasi()
        
        #expect(result == true)
        #expect(vm.daftarKonsultasi.count == 1)
        #expect(vm.daftarKonsultasi.first?.namaDokter == "dr. Lala")
        #expect(vm.daftarKonsultasi.first?.content == "Sakit kepala 3 hari")
    }
    
    @Test("Tidak berhasil membuat konsultasi jika ada field yang tidak terisi")
    func createKonsultasi_gagal() throws {
        let vm = AddKonsulViewModel()
        vm.namaDokter = "dr. Andi"
        
        let result = vm.addKonsultasi()
        
        #expect(result == false)
        #expect(vm.daftarKonsultasi.isEmpty)
    }
    
}
