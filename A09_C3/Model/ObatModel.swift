//
//  ObatModel.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 15/07/26.
//

import SwiftData
import Foundation

@Model
class Obat {
    var nama: String
    var jenis: JenisObat
    var dosis: String
    var frekuensi: String
    var keterangan: KeteranganObat
    var isKondisional: Bool
    var kondisiDetail: String?  // optional, hanya terisi kalau isKondisional true
    var createdAt: Date
    
    init(
        nama: String,
        jenis: JenisObat,
        dosis: String,
        frekuensi: String,
        keterangan: KeteranganObat,
        isKondisional: Bool = false,
        kondisiDetail: String? = nil,
        createdAt: Date = .now
    ) {
        self.nama = nama
        self.jenis = jenis
        self.dosis = dosis
        self.frekuensi = frekuensi
        self.keterangan = keterangan
        self.isKondisional = isKondisional
        self.kondisiDetail = kondisiDetail
        self.createdAt = createdAt
    }
}

enum JenisObat: String, Codable, CaseIterable, Identifiable {
    case tablet = "Tablet"
    case sirup = "Sirup"
    case kapsul = "Kapsul"
    
    var id: String { self.rawValue }
}

enum KeteranganObat: String, Codable, CaseIterable, Identifiable {
    case sebelumMakan = "Sebelum makan"
    case sesudahMakan = "Sesudah makan"
    case saatMakan = "Saat makan"
    
    var id: String { self.rawValue }
}
