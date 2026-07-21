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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading))
        : AnyLayout(HStackLayout(alignment: .top))
    }
    
    var dynamicLayoutJenis: AnyLayout {
        dynamicTypeSize >= .accessibility4
            ? AnyLayout(VStackLayout(alignment: .leading))
            : AnyLayout(HStackLayout(alignment: .center))
    }

    @State private var viewModel = ObatAddViewModel()
    @State private var selectedTab: ObatTab = .rutin

    var body: some View {
        AddModal(
            title: "Obat Baru",
            isSaveEnabled: viewModel.isFormValid,
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
                
                dynamicLayoutJenis {
                    Text("Jenis")
                    Spacer()
                    Picker("", selection: $viewModel.jenis) {
                        ForEach(JenisObat.allCases) { jenis in
                            Text(jenis.rawValue).tag(jenis)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .fixedSize()
                }

                PickerSection(viewModel: viewModel)
                
                HStack {
                    Text("Dosis")
                    HStack(spacing: 4) {
                        TextField("100", text: $viewModel.dosis)
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.dosis) { _, newValue in
                                viewModel.updateDosis(newValue)
                            }
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.satuanDosis)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if viewModel.attemptedSave && viewModel.dosis.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text("Dosis wajib diisi")
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Picker("Keterangan", selection: $viewModel.keterangan) {
                    ForEach(KeteranganObat.allCases) { keterangan in
                        Text(keterangan.rawValue).tag(keterangan)
                    }
                    .tint(.secondary)
                }

                // AC: If an Obat is conditional, user can toggle Kondisional to enable
                Picker("Jenis Jadwal", selection: $viewModel.jenisJadwal) {
                    ForEach(ObatTab.allCases) { jenis in
                        Text(jenis.rawValue)
                            .tag(jenis)
                    }
                }
                .pickerStyle(.segmented)
                .animation(.default, value: viewModel.jenisJadwal)

                // AC: If Kondisional dipilih, user bisa isi detail kondisi
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
        .alert("Batalkan penambahan obat?", isPresented: $viewModel.showCancelAlert) {
            Button("Batalkan", role: .destructive) {
                dismiss()
            }
            Button("Lanjutkan Mengedit", role: .cancel) {}
        } message: {
            Text("Jika Anda keluar sekarang, informasi obat yang telah diisi tidak akan disimpan.")
        }
        .interactiveDismissDisabled(viewModel.hasUnsavedChanges)
        .tint(.black)
    }
}

#Preview {
    ObatAddView()
        .modelContainer(for: Obat.self, inMemory: true)
}
