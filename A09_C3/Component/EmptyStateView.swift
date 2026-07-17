//
//  EmptyStateView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI

struct EmptyStateView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var isAccessibilitySize: Bool {
        dynamicTypeSize.isAccessibilitySize
    }
    
    func indonesianText(_ text: String) -> AttributedString {
        var label = AttributedString(text)
        label.setAttributes(AttributeContainer([.accessibilitySpeechLanguage: "id_ID"]))
        return label
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 70, weight: .semibold))
                .foregroundStyle(.secondary)
            
            Text(indonesianText("Belum ada data"))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            Text(indonesianText("Ketuk tombol tambah untuk memulai"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
            .ignoresSafeArea()
        EmptyStateView()
    }
}
