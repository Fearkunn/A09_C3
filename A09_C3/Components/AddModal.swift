//
//  AddModal.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import SwiftUI

struct AddModal<Content: View>: View {
    let title: String
    let onClose: () -> Void
    let onSave: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 1) {
            // Header
            HStack {
                CircleIconButton(
                    systemName: "xmark",
                    iconColor: .primary,
                    backgroundColor: Color("buttonCross").opacity(0.16),
                    action: onClose
                )

                Spacer()

                Text(title)
                    .font(.system(size: 19, weight: .semibold))

                Spacer()

                CircleIconButton(
                    systemName: "checkmark",
                    iconColor: .primary,
                    backgroundColor: .cyan,
                    action: onSave
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Form {
                content
            }
            .scrollContentBackground(.hidden)

            Spacer()
        }
        .background(Color("backgroundColor"))
    }
}

#Preview {
    AddModal(
        title: "Konsultasi Baru",
        onClose: {},
        onSave: {}
    ) {
        Section {
            
        }
    }
}
