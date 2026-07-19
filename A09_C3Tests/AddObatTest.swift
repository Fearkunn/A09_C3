//
//  AddObatTest.swift
//  A09_C3Tests
//
//  Created by Muhammad Dzakki Abdullah on 19/07/26.
//

import Testing
import SwiftData
@testable import A09_C3

@MainActor
struct ObatAddViewModelTests {

    // MARK: - Helper

    /// Membuat ModelContext in-memory supaya test tidak menyentuh data asli.
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Obat.self, configurations: config)
        return ModelContext(container)
    }

    // MARK: - Default State

    @Test("Nilai default sesuai yang diharapkan saat form pertama dibuka")
    func defaultState() {
        let viewModel = ObatAddViewModel()

        #expect(viewModel.nama.isEmpty)
        #expect(viewModel.jenis == .tablet)
        #expect(viewModel.dosis.isEmpty)
        #expect(viewModel.keterangan == .sebelumMakan)
        #expect(viewModel.isKondisional == false)
        #expect(viewModel.kondisiDetail.isEmpty)
        #expect(viewModel.jumlahPerHari == 1)
        #expect(viewModel.jumlahPerKali == 1)
        #expect(viewModel.activeChip == .jumlahPerHari)
        #expect(viewModel.isPickerExpanded == false)
        #expect(viewModel.showCancelAlert == false)
        #expect(viewModel.attemptedSave == false)
    }

    // MARK: - satuanJumlah

    @Test(
        "Satuan mengikuti Jenis obat yang dipilih",
        arguments: [
            (JenisObat.tablet, "Tablet"),
            (JenisObat.kapsul, "Kapsul"),
            (JenisObat.sirup, "Sendok")
        ]
    )
    func satuanJumlahMengikutiJenis(jenis: JenisObat, expected: String) {
        let viewModel = ObatAddViewModel()
        viewModel.jenis = jenis

        #expect(viewModel.satuanJumlah == expected)
    }

    // MARK: - frekuensiText

    @Test("frekuensiText menggabungkan jumlahPerHari dan jumlahPerKali sesuai satuan Jenis")
    func frekuensiTextTergabungDenganBenar() {
        let viewModel = ObatAddViewModel()
        viewModel.jenis = .kapsul
        viewModel.jumlahPerHari = 3
        viewModel.jumlahPerKali = 2

        #expect(viewModel.frekuensiText == "3 kali sehari, 2 Kapsul")
    }

    // MARK: - isFormValid

    @Test("Form tidak valid ketika nama kosong")
    func formTidakValidJikaNamaKosong() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = ""
        viewModel.dosis = "500mg"

        #expect(viewModel.isFormValid == false)
    }

    @Test("Form tidak valid ketika nama hanya berisi spasi")
    func formTidakValidJikaNamaHanyaSpasi() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "   "
        viewModel.dosis = "500mg"

        #expect(viewModel.isFormValid == false)
    }

    @Test("Form tidak valid ketika dosis kosong")
    func formTidakValidJikaDosisKosong() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        viewModel.dosis = ""

        #expect(viewModel.isFormValid == false)
    }

    @Test("Form valid ketika nama dan dosis terisi dan Kondisional tidak aktif")
    func formValidTanpaKondisional() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        viewModel.dosis = "500mg"
        viewModel.isKondisional = false

        #expect(viewModel.isFormValid == true)
    }

    @Test("Form tidak valid ketika Kondisional aktif tapi detail kondisi kosong")
    func formTidakValidJikaKondisionalTanpaDetail() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        viewModel.dosis = "500mg"
        viewModel.isKondisional = true
        viewModel.kondisiDetail = ""

        #expect(viewModel.isFormValid == false)
    }

    @Test("Form valid ketika Kondisional aktif dan detail kondisi terisi")
    func formValidJikaKondisionalDenganDetail() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        viewModel.dosis = "500mg"
        viewModel.isKondisional = true
        viewModel.kondisiDetail = "Saat demam"

        #expect(viewModel.isFormValid == true)
    }

    // MARK: - hasUnsavedChanges

    @Test("Tidak ada perubahan terdeteksi saat form baru dibuka")
    func tidakAdaPerubahanDiAwal() {
        let viewModel = ObatAddViewModel()

        #expect(viewModel.hasUnsavedChanges == false)
    }

    @Test("Mengisi nama dianggap sebagai perubahan")
    func mengisiNamaDianggapPerubahan() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"

        #expect(viewModel.hasUnsavedChanges == true)
    }

    @Test("Mengisi dosis dianggap sebagai perubahan")
    func mengisiDosisDianggapPerubahan() {
        let viewModel = ObatAddViewModel()
        viewModel.dosis = "500mg"

        #expect(viewModel.hasUnsavedChanges == true)
    }

    @Test("Mengaktifkan Kondisional dianggap sebagai perubahan")
    func mengaktifkanKondisionalDianggapPerubahan() {
        let viewModel = ObatAddViewModel()
        viewModel.isKondisional = true

        #expect(viewModel.hasUnsavedChanges == true)
    }

    @Test("Mengisi detail kondisi dianggap sebagai perubahan")
    func mengisiKondisiDetailDianggapPerubahan() {
        let viewModel = ObatAddViewModel()
        viewModel.kondisiDetail = "Saat demam"

        #expect(viewModel.hasUnsavedChanges == true)
    }

    // MARK: - handleClose

    @Test("handleClose langsung memanggil dismiss ketika belum ada perubahan")
    func handleCloseLangsungDismissTanpaPerubahan() {
        let viewModel = ObatAddViewModel()
        var dismissCalled = false

        viewModel.handleClose { dismissCalled = true }

        #expect(dismissCalled == true)
        #expect(viewModel.showCancelAlert == false)
    }

    @Test("handleClose menampilkan alert konfirmasi ketika sudah ada perubahan, dan tidak langsung dismiss")
    func handleCloseMenampilkanAlertJikaAdaPerubahan() {
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        var dismissCalled = false

        viewModel.handleClose { dismissCalled = true }

        #expect(dismissCalled == false)
        #expect(viewModel.showCancelAlert == true)
    }

    // MARK: - save

    @Test("save tidak menyimpan apapun dan tidak dismiss ketika form belum valid")
    func saveTidakMenyimpanJikaFormTidakValid() throws {
        let context = try makeInMemoryContext()
        let viewModel = ObatAddViewModel()
        var dismissCalled = false

        viewModel.save(modelContext: context, dismiss: { dismissCalled = true })

        let savedObat = try context.fetch(FetchDescriptor<Obat>())

        #expect(savedObat.isEmpty)
        #expect(dismissCalled == false)
        #expect(viewModel.attemptedSave == true)
    }

    @Test("save menyimpan Obat baru dengan frekuensiText yang benar dan memanggil dismiss ketika form valid")
    func saveMenyimpanObatBaruJikaFormValid() throws {
        let context = try makeInMemoryContext()
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        viewModel.dosis = "500mg"
        viewModel.jenis = .tablet
        viewModel.jumlahPerHari = 3
        viewModel.jumlahPerKali = 1
        var dismissCalled = false

        viewModel.save(modelContext: context, dismiss: { dismissCalled = true })

        let savedObat = try context.fetch(FetchDescriptor<Obat>())

        #expect(savedObat.count == 1)
        #expect(savedObat.first?.nama == "Paracetamol")
        #expect(savedObat.first?.dosis == "500mg")
        #expect(savedObat.first?.frekuensi == "3 kali sehari, 1 Tablet")
        #expect(savedObat.first?.isKondisional == false)
        #expect(savedObat.first?.kondisiDetail == nil)
        #expect(dismissCalled == true)
    }

    @Test("save mem-trim nama dan kondisiDetail sebelum disimpan ketika Kondisional aktif")
    func saveMenyimpanKondisiDetailTrimmed() throws {
        let context = try makeInMemoryContext()
        let viewModel = ObatAddViewModel()
        viewModel.nama = "  Paracetamol  "
        viewModel.dosis = "500mg"
        viewModel.isKondisional = true
        viewModel.kondisiDetail = "  Saat demam  "

        viewModel.save(modelContext: context, dismiss: {})

        let savedObat = try context.fetch(FetchDescriptor<Obat>())

        #expect(savedObat.first?.nama == "Paracetamol")
        #expect(savedObat.first?.isKondisional == true)
        #expect(savedObat.first?.kondisiDetail == "Saat demam")
    }

    @Test("save tidak mengisi kondisiDetail ketika Kondisional tidak aktif, walau field-nya terisi")
    func saveKondisiDetailNilJikaTidakKondisional() throws {
        let context = try makeInMemoryContext()
        let viewModel = ObatAddViewModel()
        viewModel.nama = "Paracetamol"
        viewModel.dosis = "500mg"
        viewModel.isKondisional = false
        viewModel.kondisiDetail = "Teks yang seharusnya diabaikan"

        viewModel.save(modelContext: context, dismiss: {})

        let savedObat = try context.fetch(FetchDescriptor<Obat>())

        #expect(savedObat.first?.kondisiDetail == nil)
    }
}
