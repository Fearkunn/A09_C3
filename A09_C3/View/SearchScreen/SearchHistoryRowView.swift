//
//  SearchHistoryRowView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 21/07/26.
//

import SwiftUI

struct SearchHistoryRowView: View {
    let item: SearchHistoryItem
    let onSelect: () -> Void
    let onDelete: () -> Void

    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: item.searchedAt, relativeTo: .now)
    }

    var body: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.query)
                    .foregroundStyle(.primary)
                Text(relativeDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.tertiary)
            }
            .buttonStyle(.borderless)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    List {
        SearchHistoryRowView(
            item: SearchHistoryItem(query: "Paracetamol", searchedAt: .now.addingTimeInterval(-86400)),
            onSelect: {},
            onDelete: {}
        )
    }
}
