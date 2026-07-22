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
        VStack(spacing: 16) {
            ScreenHeader(title: "Ringkasan", icon : "square.and.arrow.up") {
            }
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
                    .refreshable {
                        await viewModel.generateSemuaRingkasan(
                            pantauanList: pantauanList,
                            konsulList: konsulList
                        )
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                let service = RingkasanService(translationBridge: translationBridge)
                let newViewModel = RingkasanViewModel(service: service)
                viewModel = newViewModel

                Task {
                    await newViewModel.generateSemuaRingkasan(
                        pantauanList: pantauanList,
                        konsulList: konsulList
                    )
                }
            }
        }
    }
}
