//
//  RingkasanView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct RingkasanView: View {
    @Environment(TranslationBridge.self) private var translationBridge
    @State private var viewModel: RingkasanViewModel?

    @Query(sort: \PantauanModel.pantauanDate, order: .reverse)
    private var pantauanList: [PantauanModel]

    @Query(sort: \KonsulModel.tanggalKonsultasi, order: .reverse)
    private var konsulList: [KonsulModel]

    var body: some View {
        Group {
            if let viewModel {
                ScrollView {
                    VStack(spacing: 16) {
                        if !viewModel.isModelAvailable {
                            Text("Apple Intelligence belum aktif di perangkat ini. Aktifkan lewat Settings untuk memakai fitur ringkasan.")
                                .font(.caption)
                                .foregroundStyle(.orange)
                                .padding()
                        }

                        Button("Buat Ringkasan") {
                            Task {
                                await viewModel.generateSemuaRingkasan(
                                    pantauanList: pantauanList,
                                    konsulList: konsulList
                                )
                            }
                        }
                        .disabled(
                            !viewModel.isModelAvailable
                            || viewModel.isGeneratingPantauan
                            || viewModel.isGeneratingKonsultasi
                        )

                        RingkasanPantauanCard(
                            ringkasan: viewModel.ringkasanPantauan,
                            isGenerating: viewModel.isGeneratingPantauan,
                            error: viewModel.errorPantauan
                        )

                        RingkasanKonsultasiCard(
                            ringkasan: viewModel.ringkasanKonsultasi,
                            isGenerating: viewModel.isGeneratingKonsultasi,
                            error: viewModel.errorKonsultasi
                        )
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Ringkasan AI")
        .onAppear {
            if viewModel == nil {
                let service = RingkasanService(translationBridge: translationBridge)
                viewModel = RingkasanViewModel(service: service)
            }
        }
    }
}
