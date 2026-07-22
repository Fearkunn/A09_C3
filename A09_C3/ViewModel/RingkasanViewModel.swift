//
//  RingkasanViewModel.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import Observation
import Foundation

@Observable
final class RingkasanViewModel {
    private let service: RingkasanService

    var ringkasanPantauan: RingkasanPantauan?
    var ringkasanKonsultasi: RingkasanKonsultasi?
    var isGeneratingPantauan = false
    var isGeneratingKonsultasi = false
    var errorPantauan: String?
    var errorKonsultasi: String?
    // DEBUG ONLY — hapus setelah selesai isolasi
    var debugService: RingkasanService { service }
    var isModelAvailable: Bool { service.isModelAvailable }

    init(service: RingkasanService) {
        self.service = service
    }

    // AC: Data Pantauan & Konsultasi dikonversi jadi teks siap-kirim ke model AI
    func generateSemuaRingkasan(pantauanList: [PantauanModel], konsulList: [KonsulModel]) async {
        let catatanPantauan = pantauanList.map { item in
            "\(item.pantauanDate.formatted(date: .abbreviated, time: .omitted)): \(item.pantauanBody)"
        }

        let catatanKonsultasi = konsulList.map { item in
            "\(item.tanggalKonsultasi.formatted(date: .abbreviated, time: .omitted)) - dr. \(item.namaDokter): \(item.content)"
        }

        async let pantauan: Void = generatePantauan(catatan: catatanPantauan)
        async let konsultasi: Void = generateKonsultasi(catatan: catatanKonsultasi)
        _ = await (pantauan, konsultasi)
    }

    private func generatePantauan(catatan: [String]) async {
        isGeneratingPantauan = true
        defer { isGeneratingPantauan = false }
        errorPantauan = nil

        guard !catatan.isEmpty else {
            errorPantauan = "Belum ada catatan pantauan untuk diringkas"
            return
        }

        do {
            ringkasanPantauan = try await service.generateRingkasanPantauan(catatan: catatan)
        } catch {
            errorPantauan = "Gagal membuat ringkasan pantauan: \(error.localizedDescription)"
        }
    }

    private func generateKonsultasi(catatan: [String]) async {
        isGeneratingKonsultasi = true
        defer { isGeneratingKonsultasi = false }
        errorKonsultasi = nil

        guard !catatan.isEmpty else {
            errorKonsultasi = "Belum ada catatan konsultasi untuk diringkas"
            return
        }

        do {
            ringkasanKonsultasi = try await service.generateRingkasanKonsultasi(catatan: catatan)
        } catch {
            errorPantauan = "Gagal membuat ringkasan pantauan: \(error.localizedDescription)"
        }
    }
}
