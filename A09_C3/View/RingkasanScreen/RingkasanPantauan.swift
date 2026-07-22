//
//  RingkasanPantauan.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import Foundation
import FoundationModels

@Generable
struct RingkasanPantauan {
    @Guide(description: "Ringkasan tren kondisi pasien dari data pantauan dalam 2-3 kalimat, bahasa mudah dipahami")
    var ringkasan: String

    @Guide(description: "Poin perubahan penting yang terpantau, maksimal 4 poin")
    var poinPenting: [String]
}
