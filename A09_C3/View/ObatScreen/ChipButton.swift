//
//  FrekuensiChipButton.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 15/07/26.
//

import SwiftUI

// MARK: - Chip Button untuk pilihan Frekuensi
struct FrekuensiChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(isSelected ? .cyan : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(.systemGray5) : Color(.systemGray5))
                )
        }
        .buttonStyle(.plain)
    }
}
