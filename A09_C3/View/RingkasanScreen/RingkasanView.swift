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
                                Text("Apple Intelligence belum aktif di perangkat ini. Aktifkan melalui Settings untuk memakai fitur ringkasan.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding()
                            }

                            RingkasanSectionView(
                                title: "Pantauan",
                                lastUpdated: viewModel.lastUpdatedPantauan,
                                poinPenting: viewModel.poinPantauan,
                                isGenerating: viewModel.isGeneratingPantauan,
                                error: viewModel.errorPantauan
                            )

                            RingkasanSectionView(
                                title: "Konsultasi",
                                lastUpdated: viewModel.lastUpdatedKonsultasi,
                                poinPenting: viewModel.poinKonsultasi,
                                isGenerating: viewModel.isGeneratingKonsultasi,
                                error: viewModel.errorKonsultasi
                            )
                            Text("Informasi yang dirangkum AI dapat mengandung kesalahan atau ketidakakuratan. Selalu periksa kembali informasi penting dan ikuti arahan tenaga kesehatan.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal,20)
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
                newViewModel.loadCachedDisplay(pantauanList: pantauanList, konsulList: konsulList)
            }
        }
    }
}
