//
//  CircleIconButton.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import SwiftUI

struct CircleIconButton: View {
    let systemName: String
    let iconColor: Color
    let backgroundColor: Color
    var iconFont: Font = .footnote
    var isEnabled: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(iconFont.weight(.bold))
                .foregroundColor(isEnabled ? iconColor : .secondary)
                .padding(14)
                .background(
                    Circle().fill(isEnabled ? backgroundColor : Color.gray.opacity(0.16))
                )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    HStack {
        CircleIconButton(
            systemName: "xmark",
            iconColor: .primary,
            backgroundColor: Color.gray.opacity(0.16),
            action: {}
        )
        CircleIconButton(
            systemName: "checkmark",
            iconColor: .primary,
            backgroundColor: .cyan,
            isEnabled: false,
            action: {}
        )
        CircleIconButton(
            systemName: "checkmark",
            iconColor: .primary,
            backgroundColor: .cyan,
            isEnabled: true,
            action: {}
        )
    }
}
