//
//  AddKonsulViewModel.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import Foundation
import SwiftData
import Combine

class AddKonsulViewModel: ObservableObject {
    @Published var namaDokter: String = ""
    @Published var tanggalKonsultasi: Date = Date()
    @Published var content: String = ""
    
    func addKonsultasi(context: ModelContext) -> Bool {
        //validasi
        if namaDokter.isEmpty || content.isEmpty {
            return false
        }
        let konsultasi = KonsulModel(
            namaDokter: namaDokter,
            tanggalKonsultasi: tanggalKonsultasi,
            content: content
        )
        context.insert(konsultasi)
        return true
    }
}
