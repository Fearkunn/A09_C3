//
//  AddKonsul.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//


import SwiftUI

struct AddKonsul: View {
    let title: String
    let onClose: () -> Void
    let onSave: () -> Void

    var body: some View {
        HStack {
            CircleIconButton(
                systemName: "xmark",
                iconColor: .black,
                backgroundColor: Color("buttonCross").opacity(0.16),
                action: onClose
            )

            Spacer()

            Text(title)
                .font(.system(size: 19, weight: .semibold))

            Spacer()

            CircleIconButton(
                systemName: "checkmark",
                iconColor: .white,
                backgroundColor: .cyan,
                action: onSave
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    AddKonsul(title: "Konsultasi Baru", onClose: {}, onSave: {})
}
