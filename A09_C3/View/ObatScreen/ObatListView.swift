//
//  ObatListView.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 17/07/26.
//

import SwiftUI
import SwiftData

struct ObatListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Obat.createdAt, order: .reverse) private var allObat: [Obat]
    
    @State private var selectedTab: ObatTab = .rutin
    @State private var showAddSheet = false
    
    private var filteredObat: [Obat] {
        switch selectedTab {
        case .rutin:
            return allObat.filter { !$0.isKondisional }
            
        case .kondisional:
            return allObat.filter { $0.isKondisional }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ScreenHeader(title: "Obat") {
                        showAddSheet = true
                    }
                    
                    // MARK: - Filter Segmented Picker
                    Picker("Filter Obat", selection: $selectedTab) {
                        ForEach(ObatTab.allCases) { tab in
                            Text(tab.rawValue)
                                .tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // MARK: - List Konten
                    if filteredObat.isEmpty {
                        Spacer()
                        EmptyStateView()
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredObat) { obat in
                                // ObatRowView(obat: obat)
                            }
                            .onDelete(perform: deleteObat)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarHidden(true) // Menyembunyikan bar bawaan agar tidak double dengan header kustom kita
            .fullScreenCover(isPresented: $showAddSheet) {
                // ObatAddView()
            }
        }
    }
    
    private func deleteObat(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredObat[index])
        }
    }
}

#Preview {
    ObatListView()
        .modelContainer(for: Obat.self, inMemory: true)
}
