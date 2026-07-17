//
//  ObatAddView.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 15/07/26.
//

import SwiftUI
import SwiftData

struct ObatAddView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = ObatAddViewModel()

    var body: some View {
        AddModal(
            title: "Obat Baru",
            onClose: {
                viewModel.handleClose(dismiss: { dismiss() })
            },
            onSave: {
                viewModel.save(modelContext: modelContext, dismiss: { dismiss() })
            }
        ) {
            Section {
                TextField("Tambahkan Nama Obat", text: $viewModel.nama)
                if viewModel.attemptedSave && viewModel.nama.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text("Nama obat wajib diisi")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                Picker("Jenis", selection: $viewModel.jenis) {
                    ForEach(JenisObat.allCases) { jenis in
                        Text(jenis.rawValue).tag(jenis)
                    }
                }

                PickerSection(viewModel: viewModel)

                HStack {
                    Text("Dosis")
                    Spacer()
                    TextField("Tambah dosis", text: $viewModel.dosis)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }

                Picker("Keterangan", selection: $viewModel.keterangan) {
                    ForEach(KeteranganObat.allCases) { keterangan in
                        Text(keterangan.rawValue).tag(keterangan)
                    }
                }

                if viewModel.attemptedSave && viewModel.dosis.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text("Dosis wajib diisi")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                // AC: If an Obat is conditional, user can toggle Kondisional to enable
                Toggle("Kondisional", isOn: $viewModel.isKondisional.animation())

                // AC: If Kondisional toggle is enabled, user can type the condition details
                if viewModel.isKondisional {
                    TextField("Detail kondisi (cth: saat demam)", text: $viewModel.kondisiDetail)
                    if viewModel.attemptedSave && viewModel.kondisiDetail.trimmingCharacters(in: .whitespaces).isEmpty {
                        Text("Detail kondisi wajib diisi")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .alert("Apakah Anda yakin ingin membatalkan obat ini?", isPresented: $viewModel.showCancelAlert) {
            Button("Tidak", role: .cancel) { }
            Button("Hapus", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Perubahan yang sudah Anda buat tidak akan disimpan.")
        }
        .interactiveDismissDisabled(viewModel.hasUnsavedChanges)
    }
}

#Preview {
    ObatAddView()
        .modelContainer(for: Obat.self, inMemory: true)
}
