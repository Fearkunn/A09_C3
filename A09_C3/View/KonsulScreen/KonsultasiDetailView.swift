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
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var dynamicLayout: AnyLayout{
        dynamicTypeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(alignment: .top))
    }
    
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
                        backgroundColor: Color(.tertiarySystemFill),
                        action: { dismiss() }
                    )
                    .accessibilityLabel("Tombol Kembali")
                    
                    Spacer()
                    
                    EditCircleButton(
                        title: "Edit",
                        textColor: .primary,
                        backgroundColor: Color(.tertiarySystemFill),
                        action: { showEditSheet = true }
                    )
                    .accessibilityLabel("Edit Konsultasi")
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        dynamicLayout {
                            Text("Nama dokter")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(konsultasi.namaDokter)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        dynamicLayout{
                            Text("Tanggal konsultasi")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(formattedDate)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        dynamicLayout{
                            Text(konsultasi.content)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Spacer()
                        }
                        
                    }
                    .padding(.horizontal, 20)
                }
                
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
                content: "Selamat pagi ibu, setelah saya cek hanya batuk biasa aja kok. Ini saya resepkan obat batuk ya. Diminum setelah makan. Obat ini sudah tercover bpjs kok bu jadi ga usah khawatir."
            )
        )
    }
}
