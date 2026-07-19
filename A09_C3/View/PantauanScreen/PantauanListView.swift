//
//  PantauanListView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct PantauanListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PantauanModel.pantauanDate, order: .reverse) private var allPantauan: [PantauanModel]
    
    @State private var showAddSheet = false
    @State private var pantauanToDelete: PantauanModel?
    @State private var showDeleteAlert = false
    @State private var selectedPantauan: PantauanModel?
    
    private var viewModel: PantauanViewModel {
        PantauanViewModel(modelContext: modelContext)
    }
    
    private var groupedPantauan: [(month: String, items: [PantauanModel])] {
        let grouped = Dictionary(grouping: allPantauan) { pantauan in
            pantauan.pantauanDate.formatted(
                .dateTime
                    .month(.wide)
                    .year()
                    .locale(Locale(identifier: "id_ID"))
            )
        }
        return grouped
            .sorted { lhs, rhs in
                (lhs.value.first?.pantauanDate ?? .distantPast) > (rhs.value.first?.pantauanDate ?? .distantPast)
            }
            .map { (month: $0.key, items: $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                // Layer 1: Header, selalu nempel di atas
                VStack(spacing: 16) {
                    ScreenHeader(title: "Pantauan") {
                        showAddSheet = true
                    }
                    Spacer()
                }
                
                // Layer 2: Konten, independen — empty state center dari SELURUH layar
                if allPantauan.isEmpty {
                    EmptyStateView()
                } else {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 140) // sesuaikan dengan tinggi ScreenHeader
                        List {
                            ForEach(groupedPantauan, id: \.month) { group in
                                Section(group.month) {
                                    ForEach(group.items) { pantauan in
                                        Button {
                                            selectedPantauan = pantauan
                                        } label: {
                                            PantauanRowView(pantauan: pantauan)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 4)
                                        .listRowInsets(EdgeInsets())
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                pantauanToDelete = pantauan
                                                showDeleteAlert = true
                                            } label: {
                                                Label("Hapus", systemImage: "trash")
                                            }
                                            .tint(.red)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showAddSheet) {
                AddPantauan()
                    .interactiveDismissDisabled()
            }
            .navigationDestination(item: $selectedPantauan) { pantauan in
                PantauanDetailView(pantauan: pantauan)
            }
            .alert("Hapus Pantauan?", isPresented: $showDeleteAlert, presenting: pantauanToDelete) { pantauan in
                Button("Tidak", role: .cancel) {}
                Button("Hapus", role: .destructive) {
                    viewModel.delete(pantauan)
                }
            } message: { _ in
                Text("Apakah Anda yakin ingin menghapus pantauan ini?")
            }
        }
    }
}

#Preview {
    PantauanListView()
        .modelContainer(for: PantauanModel.self, inMemory: true)
}
