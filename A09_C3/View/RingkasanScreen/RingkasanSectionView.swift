//
//  RingkasanSectionView.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import SwiftUI

struct RingkasanSectionView: View {
    let title: String
    let lastUpdated: Date?
    let poinPenting: [String]
    let isGenerating: Bool
    let error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                RelativeTimeText(date: lastUpdated)
            }

            VStack(alignment: .leading, spacing: 10) {
                if isGenerating {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                } else if let error {
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                } else if poinPenting.isEmpty {
                    Text("Belum ada ringkasan")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(poinPenting, id: \.self) { poin in
                        let cleanedPoin = poin.trimmingCharacters(in: .whitespacesAndNewlines)
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("-")
                                .frame(width: 12, alignment: .leading)
                            Text(cleanedPoin)
                        }
                        .font(.body)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
