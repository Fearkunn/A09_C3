//
//  RingkasanService.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import FoundationModels
import Translation
import Observation

@Observable
final class RingkasanService {
    private let translationBridge: TranslationBridge

    // Separator dipakai untuk gabung & pisah teks saat batch translate.
    // Harus konsisten dipakai di semua tempat supaya parsing balik tidak meleset.
    private let separator = "\n===\n"

    init(translationBridge: TranslationBridge) {
        self.translationBridge = translationBridge
    }

    var isModelAvailable: Bool {
        SystemLanguageModel.default.availability == .available
    }

    func generateRingkasanPantauan(catatan: [String]) async throws -> RingkasanPantauan {
        let gabunganEN = try await translationBridge.translate(
            catatan.joined(separator: separator),
            from: Locale.Language(identifier: "id"),
            to: Locale.Language(identifier: "en")
        )

        let instructions = Instructions("""
            You are a caregiver assistant. Rephrase the following patient monitoring notes \
            in simpler words, focusing on trends and changes over time.
            """)

        let session = LanguageModelSession(instructions: instructions)
        let prompt = """
            \(gabunganEN)

            Format your response EXACTLY like this, with no extra text:
            SUMMARY: <2-3 sentence summary>
            POINTS:
            - <point 1>
            - <point 2>
            - <point 3>
            """

        let response = try await session.respond(to: prompt)
        let hasilEN = response.content

        let (ringkasanEN, poinEN) = parseFreeformResponse(hasilEN)

        let gabunganHasilEN = ([ringkasanEN] + poinEN).joined(separator: separator)
        let gabunganHasilID = try await translationBridge.translate(
            gabunganHasilEN,
            from: Locale.Language(identifier: "en"),
            to: Locale.Language(identifier: "id")
        )

        let bagianID = gabunganHasilID.components(separatedBy: separator)
        let ringkasanID = bagianID.first ?? ringkasanEN
        let poinID = Array(bagianID.dropFirst())

        return RingkasanPantauan(ringkasan: ringkasanID, poinPenting: poinID)
    }

    func generateRingkasanKonsultasi(catatan: [String]) async throws -> RingkasanKonsultasi {
        let gabunganEN = try await translationBridge.translate(
            catatan.joined(separator: separator),
            from: Locale.Language(identifier: "id"),
            to: Locale.Language(identifier: "en")
        )

        let instructions = Instructions("""
            You are a caregiver assistant. Rephrase the following medical consultation notes \
            in simpler words, focusing on what was discussed during the visit.
            """)

        let session = LanguageModelSession(instructions: instructions)
        let prompt = """
            \(gabunganEN)

            Format your response EXACTLY like this, with no extra text:
            SUMMARY: <2-3 sentence summary>
            POINTS:
            - <point 1>
            - <point 2>
            - <point 3>
            """

        let response = try await session.respond(to: prompt)
        let hasilEN = response.content

        let (ringkasanEN, poinEN) = parseFreeformResponse(hasilEN)

        let gabunganHasilEN = ([ringkasanEN] + poinEN).joined(separator: separator)
        let gabunganHasilID = try await translationBridge.translate(
            gabunganHasilEN,
            from: Locale.Language(identifier: "en"),
            to: Locale.Language(identifier: "id")
        )

        let bagianID = gabunganHasilID.components(separatedBy: separator)
        let ringkasanID = bagianID.first ?? ringkasanEN
        let poinID = Array(bagianID.dropFirst())

        return RingkasanKonsultasi(ringkasan: ringkasanID, poinPenting: poinID)
    }

    // MARK: - Parsing Helper
    // Parse format teks bebas "SUMMARY: ... / POINTS: - ..." jadi (ringkasan, [poin]).
    // Dipakai untuk MENGHINDARI @Generable karena guided generation terbukti
    // memicu refusal guardrail untuk konten kesehatan, sedangkan teks bebas tidak.
    private func parseFreeformResponse(_ text: String) -> (ringkasan: String, poin: [String]) {
        var ringkasan = ""
        var poin: [String] = []

        let lines = text.components(separatedBy: .newlines)
        var isInPoints = false

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("SUMMARY:") {
                ringkasan = trimmed.replacingOccurrences(of: "SUMMARY:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("POINTS:") {
                isInPoints = true
            } else if isInPoints, trimmed.hasPrefix("-") {
                let poinBersih = trimmed.dropFirst().trimmingCharacters(in: .whitespaces)
                if !poinBersih.isEmpty {
                    poin.append(poinBersih)
                }
            }
        }

        // Fallback: kalau parsing gagal total (model tidak ikuti format),
        // treat seluruh response sebagai ringkasan, poin dikosongkan
        if ringkasan.isEmpty && poin.isEmpty {
            ringkasan = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return (ringkasan, poin)
    }
}
