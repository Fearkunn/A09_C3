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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ScreenHeader(title: "Pantauan") {
                        showAddSheet = true
                    }
                    
                    if allPantauan.isEmpty {
                        Spacer()
                        EmptyStateView()
                        Spacer()
                    } else {
                        List {
                            ForEach(allPantauan) { pantauan in
                                // PantauanRowView(pantauan: pantauan)
                            }
                            .onDelete(perform: deletePantauan)
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
        }
    }
    
    private func deletePantauan(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(allPantauan[index])
        }
    }
}

#Preview {
    PantauanListView()
        .modelContainer(for: PantauanModel.self, inMemory: true)
}
