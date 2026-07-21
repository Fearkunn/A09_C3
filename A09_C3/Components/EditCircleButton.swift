//
//  EditCircleButton.swift
//  A09_C3
//
//  Created by Dina on 20/07/26.
//

import SwiftUI

struct EditCircleButton: View {
    let title: String
    let textColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}
