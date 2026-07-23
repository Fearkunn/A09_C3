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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
        : AnyLayout(HStackLayout(alignment: .center))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            dynamicLayout {
                Text("Frekuensi")
                Spacer()
                FrekuensiChipButton(
                    title: "\(viewModel.jumlahPerHari) kali sehari",
                    isSelected: viewModel.activeChip == .jumlahPerHari && viewModel.isPickerExpanded
                ) {
                    if reduceMotion {
                        viewModel.selectFrekuensiChip(.jumlahPerHari)
                    } else {
                        withAnimation {
                            viewModel.selectFrekuensiChip(.jumlahPerHari)
                        }
                    }
                }
                FrekuensiChipButton(
                    title: "\(viewModel.jumlahPerKali) \(viewModel.satuanJumlah)",
                    isSelected: viewModel.activeChip == .jumlahPerKali && viewModel.isPickerExpanded
                ) {
                    if reduceMotion {
                        viewModel.selectFrekuensiChip(.jumlahPerKali)
                    } else {
                        withAnimation {
                            viewModel.selectFrekuensiChip(.jumlahPerKali)
                        }
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
                    .frame(width: dynamicTypeSize >= .accessibility4 &&
                           viewModel.activeChip == .jumlahPerKali &&
                           ["Sendok", "Kapsul"].contains(viewModel.satuanJumlah)
                           ? 135
                           : nil,
                    height: 120)
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
