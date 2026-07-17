//
//  AddKonsuk.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import SwiftUI

struct AddKonsulScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var namaDokter: String = ""
    @State private var tanggalKonsultasi = Date()
    @State private var content: String = ""
    
    var body: some View {
        AddModal(
            title: "Konsultasi Baru",
            onClose: { dismiss() },
            onSave: {
                // TODO: simpan data konsultasi di sini
                dismiss()
            }
        ) {
            Section {
                TextField(text: $namaDokter, prompt: Text("Nama Dokter")) {
                    Text("Nama")
                }
                DatePicker(
                    "Tanggal Konsultasi",
                    selection: $tanggalKonsultasi,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
            }
            
            Section {
                TextField(
                    "Content",
                    text: $content,
                    prompt: Text("Ketik atau ketuk ikon mikrofon untuk berbicara"),
                    axis: .vertical
                )
                .lineLimit(8...40)
            }
        }
    }
}


#Preview {
    AddKonsulScreen()
}

