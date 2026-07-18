//
//  ObatRowView.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 18/07/26.
//

import SwiftUI

struct ObatRowView: View {

    let obat: Obat

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            HStack {
                Text(obat.nama)
                    .font(.body.bold())

                Spacer()

                Text(obat.keterangan.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("\(obat.frekuensi)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if obat.isKondisional,
               let detail = obat.kondisiDetail,
               !detail.isEmpty {

                Text("Kondisi: \(detail)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    // Optional Preview
}
