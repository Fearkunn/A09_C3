import SwiftUI
import SwiftData

struct ObatListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Obat.createdAt, order: .reverse)
    private var allObat: [Obat]

    @State private var selectedTab: ObatTab = .rutin
    @State private var showAddSheet = false
    @State private var showDeleteAlert = false
    @State private var obatToDelete: Obat?

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

                VStack{

                    ScreenHeader(title: "Obat") {
                        showAddSheet = true
                    }
      

                    Picker("Filter Obat", selection: $selectedTab) {
                        ForEach(ObatTab.allCases) { tab in
                            Text(tab.rawValue)
                                .tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    Spacer()

                    if filteredObat.isEmpty {
                        EmptyStateView(message: "Ketuk tombol tambah untuk menambah obat")
                        Spacer()
                    }
                    else {
                        List {
                            Section {
                                ForEach(filteredObat) { obat in
                                    ObatRowView(obat: obat)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button {
                                                obatToDelete = obat
                                                showDeleteAlert = true
                                            } label: {
                                                Label("Hapus", systemImage: "trash")
                                            }
                                            .tint(.red)
                                        }
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
                ObatAddView()
                    .interactiveDismissDisabled()
            }
        }
        .alert("Hapus Obat?", isPresented: $showDeleteAlert) {

            Button("Batal", role: .cancel) {
                obatToDelete = nil
            }
                .tint(.black)

            Button("Hapus", role: .destructive) {
                if let obat = obatToDelete {
                    modelContext.delete(obat)

                    do {
                        try modelContext.save()
                    } catch {
                        print("Gagal menghapus obat: \(error)")
                    }

                    obatToDelete = nil
                }
            }

        } message: {
            Text("Apakah anda yakin untuk menghapus obat ini?")
        }
    }
}

#Preview {
    ObatListView()
        .modelContainer(for: Obat.self, inMemory: true)
}
