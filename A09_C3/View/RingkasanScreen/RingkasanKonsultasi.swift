//
//  RingkasanKonsultasi.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import FoundationModels

@Generable
struct RingkasanKonsultasi {
    @Guide(description: "Ringkasan hasil konsultasi dalam 2-3 kalimat, bahasa mudah dipahami")
    var ringkasan: String

    @Guide(description: "Poin-poin penting dari konsultasi, maksimal 5 poin")
    var poinPenting: [String]

//    @Guide(description: "Rekomendasi tindak lanjut untuk caregiver, jika ada")
//    var rekomendasi: String?
}
