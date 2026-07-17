//
//  RingkasanView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI

struct RingkasanView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            Text("Ringkasan — coming soon")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    RingkasanView()
}
