//
//  KonsulView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct KonsulListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KonsulModel.tanggalKonsultasi, order: .reverse) private var allKonsul: [KonsulModel]

    @State private var showAddSheet = false

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
                            ForEach(allKonsul) { konsul in
                                // KonsulRowView(konsul: konsul)
                            }
                            .onDelete(perform: deleteKonsul)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showAddSheet) {
                AddKonsul()
                    .interactiveDismissDisabled()
            }
        }
    }

    private func deleteKonsul(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(allKonsul[index])
        }
    }
}

#Preview {
    KonsulListView()
        .modelContainer(for: KonsulModel.self, inMemory: true)
}
