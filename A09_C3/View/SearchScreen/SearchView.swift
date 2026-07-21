//
//  SearchView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var searchText: String
    @State private var viewModel: SearchViewModel?
    
    @State private var selectedObat: Obat?
    @State private var selectedPantauan: PantauanModel?
    @State private var selectedKonsul: KonsulModel?
    
    private var trimmedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pencarian")
                .font(.largeTitle.bold())
            
            if trimmedQuery.isEmpty {
                Text("Ketik kata kunci untuk mencari obat,\npantauan, atau konsultasi.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: trimmedQuery.isEmpty)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor").ignoresSafeArea()
            
            if let viewModel {
                VStack(alignment: .leading, spacing: 0) {
                    
                    header
                    
                    content(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = SearchViewModel(modelContext: modelContext)
            }
        }
        .onSubmit(of: .search) {
            guard !trimmedQuery.isEmpty else { return }
            viewModel?.commitSearch(trimmedQuery)
        }
        .navigationDestination(item: $selectedPantauan) { pantauan in
            PantauanDetailView(pantauan: pantauan)
        }
        .navigationDestination(item: $selectedKonsul) { konsul in
            KonsulDetailView(konsultasi: konsul)
        }
    }
    
    @ViewBuilder
    private func content(viewModel: SearchViewModel) -> some View {
        if trimmedQuery.isEmpty {
            historySection(viewModel: viewModel)
        } else {
            let results = viewModel.groupedResults(for: trimmedQuery)
            if results.isEmpty {
                SearchNotFoundView(query: trimmedQuery)
            } else {
                resultsSection(results: results)
            }
        }
    }
    
    @ViewBuilder
    private func historySection(viewModel: SearchViewModel) -> some View {
        if viewModel.historyStore.items.isEmpty {
            Color.clear
        } else {
            List {
                Section("Riwayat") {
                    ForEach(viewModel.historyStore.items) { item in
                        SearchHistoryRowView(
                            item: item,
                            onSelect: {
                                searchText = viewModel.selectHistory(item)
                            },
                            onDelete: {
                                viewModel.historyStore.remove(item)
                            }
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
    }
    
    private func resultsSection(
        results: [(category: SearchCategory, items: [SearchResultItem])]
    ) -> some View {
        List {
            ForEach(results, id: \.category) { group in
                Section(group.category.rawValue) {
                    ForEach(group.items) { item in
                        SearchResultRowView(item: item, keyword: trimmedQuery)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                handleSelection(item)
                            }
                            .allowsHitTesting(item.category != .obat)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .listSectionSpacing(.compact)
        .scrollContentBackground(.hidden)
    }
    
    private func handleSelection(_ item: SearchResultItem) {
        switch item.destination {
        case .obat(let obat):
            selectedObat = obat
        case .pantauan(let pantauan):
            selectedPantauan = pantauan
        case .konsul(let konsul):
            selectedKonsul = konsul
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    
    NavigationStack {
        SearchView(searchText: $text)
            .searchable(text: $text)
    }
    .modelContainer(for: [Obat.self, PantauanModel.self, KonsulModel.self], inMemory: true)
}
