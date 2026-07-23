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

    init(translationBridge: TranslationBridge) {
        self.translationBridge = translationBridge
    }

    var isModelAvailable: Bool {
        SystemLanguageModel.default.availability == .available
    }

    // Satu catatan -> satu poin ringkasan
    func generatePoinPantauan(catatan: String) async throws -> String {
        let catatanEN = try await translationBridge.translate(
            catatan,
            from: Locale.Language(identifier: "id"),
            to: Locale.Language(identifier: "en")
        )

        let instructions = Instructions("""
            You are a caregiver assistant. Rephrase the following single patient monitoring note \
            in simpler words, as ONE short sentence.
            """)

        let session = LanguageModelSession(instructions: instructions)
        let prompt = """
            \(catatanEN)

            Respond with ONLY one short sentence summarizing this note. No prefix, no label, no extra text.
            """

        let response = try await session.respond(to: prompt)
        let poinEN = response.content.trimmingCharacters(in: .whitespacesAndNewlines)

        let poinID = try await translationBridge.translate(
            poinEN,
            from: Locale.Language(identifier: "en"),
            to: Locale.Language(identifier: "id")
        )

        return poinID.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Satu catatan konsultasi -> satu poin ringkasan
    func generatePoinKonsultasi(catatan: String) async throws -> String {
        let catatanEN = try await translationBridge.translate(
            catatan,
            from: Locale.Language(identifier: "id"),
            to: Locale.Language(identifier: "en")
        )

        let instructions = Instructions("""
            You are a caregiver assistant. Rephrase the following single medical consultation note \
            in simpler words, as ONE short sentence.
            """)

        let session = LanguageModelSession(instructions: instructions)
        let prompt = """
            \(catatanEN)

            Respond with ONLY one short sentence summarizing this note. No prefix, no label, no extra text.
            """

        let response = try await session.respond(to: prompt)
        let poinEN = response.content.trimmingCharacters(in: .whitespacesAndNewlines)

        let poinID = try await translationBridge.translate(
            poinEN,
            from: Locale.Language(identifier: "en"),
            to: Locale.Language(identifier: "id")
        )

        return poinID.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
