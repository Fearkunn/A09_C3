//
//  ObatRowView.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 18/07/26.
//

import SwiftUI

struct ObatRowView: View {

    let obat: Obat

    var body: some View {
        VStack(alignment: .leading) {

            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(obat.nama)
                        .font(.body)
                    
                    Text(obat.frekuensi)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if obat.isKondisional,
                       let detail = obat.kondisiDetail,
                       !detail.isEmpty {
                        
                        Text("Kondisi: \(detail)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                VStack (alignment: .trailing, spacing: 4){
                    Text(obat.keterangan.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                    Text(obat.dosis)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
//        .padding(.vertical)
        .contentShape(Rectangle())
    }
}

#Preview {
    let obat = Obat(
        nama: "Paracetamol",
        jenis: .tablet,
        dosis: "1 tablet",
        frekuensi: "3 × sehari 1 tablet",
        keterangan: .sebelumMakan
    )

    ObatRowView(obat: obat)
        .padding()
}
