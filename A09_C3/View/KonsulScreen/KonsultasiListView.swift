import SwiftUI
import SwiftData

struct KonsulListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KonsulModel.tanggalKonsultasi, order: .reverse)
    private var allKonsul: [KonsulModel]
    
    @State private var konsultasiToDelete: KonsulModel?
    @State private var showAddSheet = false
    @State private var showDeleteAlert = false
    
    private var konsulViewModel: KonsultasiViewModel {
        KonsultasiViewModel(modelContext: modelContext)
    }
    
    //grup berdasarkan bulan
    private var groupedKonsul: [(key: String, items: [KonsulModel])] {
        let grouped = Dictionary(grouping: allKonsul) { konsul in
            konsul.tanggalKonsultasi.formatted(.dateTime.month(.wide).year()
                .locale(Locale(identifier: "id_ID")))
            
        }
        //berdasarkan tanggal paling baru
        return grouped.sorted { lhs, rhs in
            guard let lhsDate = lhs.value.first?.tanggalKonsultasi,
                  let rhsDate = rhs.value.first?.tanggalKonsultasi else {
                return false
            }
            return lhsDate > rhsDate
        }.map { (key: $0.key, items: $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ScreenHeader(title: "Konsultasi") {
                        showAddSheet = true
                    }
                    
                    if allKonsul.isEmpty {
                        Spacer()
                        EmptyStateView()
                        Spacer()
                    } else {
                        List {
                            ForEach(groupedKonsul, id: \.key) { group in
                                Section {
                                    ForEach(group.items) { konsul in
                                        KonsulRowView(konsul: konsul)
                                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                Button {
                                                    konsultasiToDelete = konsul
                                                    showDeleteAlert = true
                                                } label: {
                                                    Label("Hapus", systemImage: "trash")
                                                }
                                                .tint(.red)
                                            }
                                    }
                                } header: {
                                    Text(group.key)
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
                AddKonsul()
                    .interactiveDismissDisabled()
            }
            .alert("Hapus Konsultasi?", isPresented: $showDeleteAlert, presenting: konsultasiToDelete) { konsultasi in
                Button("Tidak", role: .cancel) {}
                Button("Hapus", role: .destructive) {
                    konsulViewModel.delete(konsultasi)
                }
            } message: { _ in
                Text("Apakah Anda yakin ingin menghapus konsultasi ini?")
            }
        }
    }
}

#Preview {
    KonsulListView()
        .modelContainer(for: KonsulModel.self, inMemory: true)
}
