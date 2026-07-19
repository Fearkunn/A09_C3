//
//  MainTabView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab: AppTab = .obat

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Ringkasan", systemImage: "list.bullet.rectangle", value: .ringkasan) {
                RingkasanView()
            }

            Tab("Obat", systemImage: "pills.fill", value: .obat) {
                ObatListView()
            }

            Tab("Pantauan", systemImage: "calendar.and.person", value: .pantauan) {
                PantauanListView()
            }

            Tab("Konsultasi", systemImage: "stethoscope", value: .konsultasi) {
                KonsulListView()
            }

            Tab(value: .search, role: .search) {
                SearchView()
            }
        }
        .tint(Color(.cyan))
    }
}

#Preview {
    MainTabView()
        .modelContainer(
            for: [Obat.self, PantauanModel.self, KonsulModel.self],
            inMemory: true
        )
}
