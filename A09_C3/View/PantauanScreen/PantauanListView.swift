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
                
                VStack(spacing: 16) {
                    ScreenHeader(title: "Pantauan") {
                        showAddSheet = true
                    }
                    Spacer()
                }
                
                if allPantauan.isEmpty {
                    EmptyStateView(message: "Ketuk tombol tambah untuk mencatat pantauan")
                } else {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 60)
                        List {
                            ForEach(groupedPantauan, id: \.month) { group in
                                Section {
                                    ForEach(group.items) { pantauan in
                                        PantauanRowView(pantauan: pantauan)
                                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                Button {
                                                    pantauanToDelete = pantauan
                                                    showDeleteAlert = true
                                                } label: {
                                                    Label("Hapus", systemImage: "trash")
                                                }
                                                .tint(.red)
                                            }
                                    }
                                } header: {
                                    Text(group.month)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showAddSheet) {
                AddPantauan()
                    .interactiveDismissDisabled()
            }
            .alert("Hapus Pantauan?", isPresented: $showDeleteAlert, presenting: pantauanToDelete) { pantauan in
                Button("Tidak", role: .cancel) {}
                    .tint(.black)
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
