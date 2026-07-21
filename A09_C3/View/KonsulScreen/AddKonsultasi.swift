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
    @State private var errorMessageName: String?
    
    private var modalTitle: String {
        konsultasiToEdit == nil ? "Konsultasi Baru" : "Edit Konsultasi"
    }
    
    private func isValidDokterName(_ name: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: ".,"))
        return name.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
    }
    
    private var cancelAlertTitle: String {
        konsultasiToEdit == nil ? "Batalkan penambahan konsultasi?" : "Batalkan perubahan?"
    }
    
    private var cancelAlertMessage: String {
        konsultasiToEdit == nil
        ? "Jika Anda keluar sekarang, informasi konsultasi yang telah diisi tidak akan disimpan."
        : "Jika Anda kembali sekarang, semua perubahan yang telah dibuat akan hilang."
    }
    
    private var hasUnsavedChanges: Bool {
        guard let konsultasiToEdit else {
            return !namaDokter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return namaDokter != konsultasiToEdit.namaDokter || tanggalKonsultasi != konsultasiToEdit.tanggalKonsultasi || content != konsultasiToEdit.content
    }
    
    private var isSaveEnabled: Bool {
        guard konsultasiToEdit != nil else {
            return !namaDokter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return hasUnsavedChanges
    }
    
    var body: some View {
        AddModal(
            title: modalTitle,
            isSaveEnabled: isSaveEnabled,
            onClose: { handleClose() },
            onSave: {
                save() }
        ) {
            Section {
                TextField(text: $namaDokter, prompt: Text("Nama Dokter")) {
                    Text("Nama")
                }
                if let errorMessageName {
                    Text(errorMessageName)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                ExpandableDatePicker(label: "Tanggal konsultasi", selection: $tanggalKonsultasi)
            }
            
            Section {
                ScrollView{
                    ZStack(alignment: .bottomTrailing) {
                        TextField(
                            "Content",
                            text: $content,
                            prompt: Text("Ketik atau ketuk ikon mikrofon untuk berbicara"),
                            axis: .vertical
                        )
                        .autocorrectionDisabled()
                        .lineLimit(8...100)
                        .padding(.trailing, 44)
                        
                        DictationButton(
                            dictationManager: dictationManager,
                            text: $content,
                            onError: { message in errorMessage = message }
                        )
                        .padding(8)
                    }
                }
                
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        
        .onAppear(perform: loadExistingData)
        .alert(cancelAlertTitle, isPresented: $showCancelAlert) {
            Button("Batalkan", role: .destructive) {
                dismiss()
            }
            Button("Lanjutkan Mengedit", role: .cancel) {}
        } message: {
            Text(cancelAlertMessage)
        }
        .tint(.black)
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
        
        guard isValidDokterName(namaDokter) else {
            print("Nama gagal validasi: '\(namaDokter)'")
            errorMessageName = "Nama dokter tidak boleh mengandung angka atau simbol (selain titik)"
            return
        }
        
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

