//
//  FrekuensiPickerSection.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 15/07/26.
//

import SwiftUI

// MARK: - Section Frekuensi (chip pilihan + wheel picker angka)
// AC: User can input Obat details manually — Frekuensi (kali sehari & jumlah per konsumsi)
struct PickerSection: View {
    @Bindable var viewModel: ObatAddViewModel

    var body: some View {
        HStack {
            Text("Frekuensi")
            Spacer()
            FrekuensiChipButton(
                title: "\(viewModel.jumlahPerHari) kali sehari",
                isSelected: viewModel.activeChip == .jumlahPerHari && viewModel.isPickerExpanded
            ) {
                withAnimation {
                    viewModel.activeChip = .jumlahPerHari
                    viewModel.isPickerExpanded = true
                }
            }
            FrekuensiChipButton(
                title: "\(viewModel.jumlahPerKali) \(viewModel.satuanJumlah)",
                isSelected: viewModel.activeChip == .jumlahPerKali && viewModel.isPickerExpanded
            ) {
                withAnimation {
                    viewModel.activeChip = .jumlahPerKali
                    viewModel.isPickerExpanded = true
                }
            }
        }

        // Wheel picker angka. Hanya tampil setelah salah satu chip di atas di-tap,
        // jadi saat halaman baru dibuka pickernya belum muncul.
        if viewModel.isPickerExpanded {
            HStack {
                Picker("", selection: wheelSelection) {
                    ForEach(1...20, id: \.self) { angka in
                        Text("\(angka)").tag(angka)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
                .clipped()
                // Force SwiftUI bikin ulang wheel-nya tiap kali chip berpindah,
                // supaya nilai yang ditampilkan langsung sinkron tanpa perlu tap dulu.
                .id(viewModel.activeChip)

                Text(viewModel.activeChip == .jumlahPerHari ? "kali" : viewModel.satuanJumlah)
                    .font(.body.weight(.semibold))
                    .padding(.trailing, 8)
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    // Satu sumber Binding untuk wheel picker, menghindari SwiftUI bingung
    // saat selection ditukar lewat ternary (Binding instance berbeda tiap render).
    private var wheelSelection: Binding<Int> {
        Binding(
            get: {
                viewModel.activeChip == .jumlahPerHari
                    ? viewModel.jumlahPerHari
                    : viewModel.jumlahPerKali
            },
            set: { newValue in
                if viewModel.activeChip == .jumlahPerHari {
                    viewModel.jumlahPerHari = newValue
                } else {
                    viewModel.jumlahPerKali = newValue
                }
            }
        )
    }
}
