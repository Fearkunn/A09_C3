//
//  PantauanDetailView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 19/07/26.
//

import SwiftUI

struct PantauanDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let pantauan: PantauanModel
    
    @State private var showEditSheet = false
    
    private var formattedDate: String {
        pantauan.pantauanDate.formatted(
            .dateTime
                .day()
                .month(.wide)
                .year()
                .locale(Locale(identifier: "id_ID"))
        )
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack {
                    CircleIconButton(
                        systemName: "chevron.left",
                        iconColor: .black,
                        backgroundColor: Color.gray.opacity(0.16),
                        action: { dismiss() }
                    )
                    
                    Spacer()
                    
                    CircleIconButton(
                        systemName: "pencil",
                        iconColor: .white,
                        backgroundColor: .cyan,
                        action: { showEditSheet = true }
                    )
                    .accessibilityLabel("Edit Pantauan")
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Tanggal pantauan")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(formattedDate)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(pantauan.pantauanBody)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showEditSheet) {
            AddPantauan(pantauanToEdit: pantauan)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    NavigationStack {
        PantauanDetailView(
            pantauan: PantauanModel(pantauanDate: .now, pantauanBody: "Sakit tenggorokan batuk batuk batuk")
        )
    }
}
