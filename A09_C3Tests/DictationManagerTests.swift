//
//  DictationManagerTests.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 19/07/26.
//

import Testing
@testable import A09_C3

struct DictationManagerTests {
    
    @Test("Menambahkan teks baru ke teks lama dengan spasi pemisah")
    func appendTranscription_addsToExistingText() {
        let manager = DictationManager()
        let result = manager.appendTranscription(existingText: "Sakit kepala", newText: "batuk pilek")
        #expect(result == "Sakit kepala batuk pilek")
    }
    
    @Test("Teks baru pada textfield kosong tidak menambahkan spasi di depan")
    func appendTranscription_onEmptyText_returnsNewTextOnly() {
        let manager = DictationManager()
        let result = manager.appendTranscription(existingText: "", newText: "batuk pilek")
        #expect(result == "batuk pilek")
    }
}
