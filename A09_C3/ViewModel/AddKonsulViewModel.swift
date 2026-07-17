//
//  AddKonsulViewModel.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import Foundation
import Combine


class AddKonsulViewModel: ObservableObject {
    @Published var namaDokter: String = ""
    @Published var tanggalKonsultasi: Date = Date()
    @Published var content: String = ""
    
    @Published private(set) var daftarKonsultasi: [KonsulModel] = []
    
    func addKonsultasi() -> Bool {
        //validasi
        if namaDokter.isEmpty || content.isEmpty {
            return false
        }
        let konsultasi = KonsulModel(
            namaDokter: namaDokter,
            tanggalKonsultasi: tanggalKonsultasi,
            content: content
        )
        daftarKonsultasi.append(konsultasi)
        return true
    }
}
