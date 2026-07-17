//
//  ObatEmptyStateScren.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 17/07/26.
//

import SwiftUI

struct ObatEmptyStateView: View {

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "list.clipboard")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)

            Text("Belum ada data")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Ketuk tombol tambah untuk memulai")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ObatEmptyStateView()
}
