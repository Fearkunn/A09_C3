//
//  KonsulDetailView.swift
//  A09_C3
//
//  Created by Dina on 19/07/26.
//

import SwiftUI
 
struct KonsulDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let konsultasi: KonsulModel
 
    @State private var showEditSheet = false
 
    private var formattedDate: String {
        konsultasi.tanggalKonsultasi.formatted(
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
                    .accessibilityLabel("Edit Konsultasi")
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
 
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Nama dokter")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(konsultasi.namaDokter)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
 
                    HStack {
                        Text("Tanggal konsultasi")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(formattedDate)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
 
                    Text(konsultasi.content)
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
            AddKonsul(konsultasiToEdit: konsultasi)
                .interactiveDismissDisabled()
        }
    }
}
 
#Preview {
    NavigationStack {
        KonsulDetailView(
            konsultasi: KonsulModel(
                namaDokter: "dr. Lala",
                tanggalKonsultasi: .now,
                content: "Sakit kepala 3 hari, sudah minum obat pereda nyeri"
            )
        )
    }
}
