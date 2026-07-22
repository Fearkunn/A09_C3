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
    @State private var searchText: String = ""
    @State private var historyStore = SearchHistoryStore()
    @State private var commitTask: Task<Void, Never>?
    
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
                NavigationStack {
                    SearchView(searchText: $searchText, historyStore: historyStore)
                        .searchable(
                            text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Cari \"Paracetamol\" atau \"batuk\""
                        )
                }
            }
        }
        .tint(.cyan)
        .onChange(of: searchText) { _, newValue in
            commitTask?.cancel()
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            
            commitTask = Task {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                historyStore.add(query: trimmed)
            }
        }
    }
}
