//
//  ScreenHeader.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI

struct ScreenHeader: View {
    var title: String
    var icon: String = "plus"
    var accessibilityActionLabel: String? = nil
    let addAction: () -> Void

    var body: some View {
        HStack {
            Text(indonesianText(title))
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            CircleIconButton(
                systemName: icon,
                iconColor: .white,
                backgroundColor: .cyan,
                size: 48,
                iconSize: 22,
                isProminent: true,
                action: addAction
            )
            .accessibilityLabel(Text(indonesianText(accessibilityActionLabel ?? "Tambah \(title)")))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
            .ignoresSafeArea()
        VStack {
            ScreenHeader(title: "Obat") {}
            Spacer()
        }
    }
}
