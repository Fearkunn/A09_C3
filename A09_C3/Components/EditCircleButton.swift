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
    var minSize: CGFloat = 40
    var cornerRadius: CGFloat = 40
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24))
                .foregroundStyle(textColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(minWidth: minSize, minHeight: minSize)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
