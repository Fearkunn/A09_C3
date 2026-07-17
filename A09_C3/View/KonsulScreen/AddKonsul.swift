//
//  AddKonsuk.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import SwiftUI

struct AddKonsul: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddKonsulViewModel()
    @State private var showError = false
//    
//    @State private var namaDokter: String = ""
//    @State private var tanggalKonsultasi = Date()
//    @State private var content: String = ""
//    
    var body: some View {
        AddModal(
            title: "Konsultasi Baru",
            onClose: { dismiss() },
            onSave: {
                if viewModel.addKonsultasi() {
                    dismiss()
                } else {
                    showError = true
                }
            }
        ) {
            Section {
                TextField(text: $viewModel.namaDokter, prompt: Text("Nama Dokter")) {
                    Text("Nama")
                }
                DatePicker(
                    "Tanggal Konsultasi",
                    selection: $viewModel.tanggalKonsultasi,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
            }
            
            Section {
                TextField(
                    "Content",
                    text: $viewModel.content,
                    prompt: Text("Ketik atau ketuk ikon mikrofon untuk berbicara"),
                    axis: .vertical
                )
                .lineLimit(8...40)
            }
        }
    }
}


#Preview {
    AddKonsul()
}

