//
//  AddKonsul.swift
//  A09_C3
//
//  Created by Dina on 17/07/26.
//

import SwiftUI
import SwiftData

struct AddKonsul: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var konsultasiToEdit: KonsulModel?
    
    @State private var namaDokter: String = ""
    @State private var tanggalKonsultasi: Date = .now
    @State private var content: String = ""
    @State private var dictationManager = DictationManager()
    @State private var errorMessage: String?
    @State private var showCancelAlert = false
    
    private var modalTitle: String {
        konsultasiToEdit == nil ? "Konsultasi Baru" : "Edit Konsultasi"
    }
    
    private var hasUnsavedChanges: Bool {
        guard let konsultasiToEdit else {
            return !namaDokter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return namaDokter != konsultasiToEdit.namaDokter || tanggalKonsultasi != konsultasiToEdit.tanggalKonsultasi || content != konsultasiToEdit.content
    }
    
    var body: some View {
        AddModal(
            title: modalTitle,
            onClose: { handleClose() },
            onSave: {
                save() }
        ) {
            Section {
                TextField(text: $namaDokter, prompt: Text("Nama Dokter")) {
                    Text("Nama")
                }
                DatePicker(
                    "Tanggal konsultasi",
                    selection: $tanggalKonsultasi,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: "id_ID")) //memaksa jadi bahasa indo
            }
            
            Section {
                ZStack(alignment: .bottomTrailing) {
                    TextField(
                        "Content",
                        text: $content,
                        prompt: Text("Ketik atau ketuk ikon mikrofon untuk berbicara"),
                        axis: .vertical
                    )
                    .lineLimit(8...40)
                    .padding(.trailing, 44)
                    
                    DictationButton(
                        dictationManager: dictationManager,
                        text: $content,
                        onError: { message in errorMessage = message }
                    )
                    .padding(8)
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
    
        .onAppear(perform: loadExistingData)
        .alert("Apakah Anda yakin ingin menghapus konsultasi ini?", isPresented: $showCancelAlert) {
            Button("Tidak", role: .cancel) {}
            Button("Hapus", role: .destructive) {
                dismiss()
            }
        }
}

private func loadExistingData() {
    guard let konsultasiToEdit else { return }
    namaDokter = konsultasiToEdit.namaDokter
    tanggalKonsultasi = konsultasiToEdit.tanggalKonsultasi
    content = konsultasiToEdit.content
}

private func handleClose() {
    if hasUnsavedChanges {
        showCancelAlert = true
    } else {
        dismiss()
    }
}


private func save() {
    let viewModel = KonsultasiViewModel(modelContext: modelContext)
    
    do {
        if let konsultasiToEdit {
            try viewModel.update(
                konsultasiToEdit,
                namaDokter: namaDokter,
                tanggal: tanggalKonsultasi,
                content: content)
        } else {
            try viewModel.addKonsultasi(
                namaDokter: namaDokter,
                tanggal: tanggalKonsultasi,
                content: content)
        }
        dismiss()
    } catch KonsultasiValidationError.emptyDokter {
        errorMessage = "Nama dokter tidak boleh kosong"
    } catch KonsultasiValidationError.emptyBody {
        errorMessage = "Catatan tidak boleh kosong"
    } catch {
        errorMessage = "Terjadi kesalahan, coba lagi"
    }
}

}


#Preview {
    AddKonsul()
        .modelContainer(for: KonsulModel.self, inMemory: true)
}

