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
            VStack(spacing: 16) {
                
                // MARK: - Custom Header (Judul & Tombol Kanan Atas)
                HStack {
                    Text("Obat")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action:  {
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle().fill(.cyan)
                            )
                    }
                    .offset(y: -50)
                    .accessibilityLabel("Tombol Tambah")
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

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
                    ObatEmptyStateView()
                } else {
                    List {
                        ForEach(filteredObat) { obat in
                            // ObatRowView(obat: obat)
                        }
                        .onDelete(perform: deleteObat)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarHidden(true) // Menyembunyikan bar bawaan agar tidak double dengan header kustom kita
            .sheet(isPresented: $showAddSheet) {
//                 ObatAddView()
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
