//
//  RingkasanKonsultasiCard.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import SwiftUI

struct RingkasanKonsultasiCard: View {
    let ringkasan: RingkasanKonsultasi?
    let isGenerating: Bool
    let error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ringkasan Konsultasi")
                .font(.headline)

            if isGenerating {
                ProgressView()
            } else if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            } else if let ringkasan {
                Text(ringkasan.ringkasan)
                ForEach(ringkasan.poinPenting, id: \.self) { poin in
                    Label(poin, systemImage: "circle.fill")
                        .font(.caption)
                }
            } else {
                Text("Belum ada ringkasan")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}
