//
//  AddPantauan.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct AddPantauan: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var pantauanToEdit: PantauanModel?
    
    @State private var pantauanDate: Date = .now
    @State private var pantauanBody: String = ""
    @State private var dictationManager = DictationManager()
    @State private var errorMessage: String?
    @State private var showCancelAlert = false
    
    private var modalTitle: String {
        pantauanToEdit == nil ? "Pantauan Baru" : "Edit Pantauan"
    }
    
    private var hasUnsavedChanges: Bool {
        guard let pantauanToEdit else {
            return !pantauanBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return pantauanBody != pantauanToEdit.pantauanBody || pantauanDate != pantauanToEdit.pantauanDate
    }
    
    var body: some View {
        AddModal(
            title: modalTitle,
            onClose: { handleClose() },
            onSave: { save() }
        ) {
            Section {
                DatePicker(
                    "Tanggal Pantauan",
                    selection: $pantauanDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
            }
            
            Section {
                ZStack(alignment: .bottomTrailing) {
                    TextField(
                        "Catatan",
                        text: $pantauanBody,
                        prompt: Text("Ketik atau ketuk ikon mikrofon untuk berbicara"),
                        axis: .vertical
                    )
                    .lineLimit(8...40)
                    .padding(.trailing, 44)
                    
                    DictationButton(
                        dictationManager: dictationManager,
                        text: $pantauanBody,
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
        .alert("Apakah Anda yakin ingin menghapus pantauan ini?", isPresented: $showCancelAlert) {
            Button("Tidak", role: .cancel) {}
            Button("Hapus", role: .destructive) {
                dismiss()
            }
        }
    }
    
    private func loadExistingData() {
        guard let pantauanToEdit else { return }
        pantauanDate = pantauanToEdit.pantauanDate
        pantauanBody = pantauanToEdit.pantauanBody
    }
    
    private func handleClose() {
        if hasUnsavedChanges {
            showCancelAlert = true
        } else {
            dismiss()
        }
    }
    
    private func save() {
        let viewModel = PantauanViewModel(modelContext: modelContext)
        
        do {
            if let pantauanToEdit {
                try viewModel.update(pantauanToEdit, date: pantauanDate, body: pantauanBody)
            } else {
                try viewModel.add(date: pantauanDate, body: pantauanBody)
            }
            dismiss()
        } catch PantauanValidationError.emptyBody {
            errorMessage = "Catatan tidak boleh kosong"
        } catch {
            errorMessage = "Terjadi kesalahan, coba lagi"
        }
    }
}

#Preview("Add Mode") {
    AddPantauan()
        .modelContainer(for: PantauanModel.self, inMemory: true)
}

#Preview("Edit Mode") {
    AddPantauan(pantauanToEdit: PantauanModel(pantauanDate: .now, pantauanBody: "Sakit tenggorokan"))
        .modelContainer(for: PantauanModel.self, inMemory: true)
}
