//
//  SearchHistoryStoreTests.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 21/07/26.
//

import Testing
import Foundation
@testable import A09_C3

@Suite("SearchHistoryStore Tests")
struct SearchHistoryStoreTests {

    private func makeSUT() -> SearchHistoryStore {
        let suiteName = "test_\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        return SearchHistoryStore(defaults: defaults)
    }

    @Test("Menambah query baru muncul di urutan pertama")
    func add_insertsAtFront() {
        let sut = makeSUT()
        sut.add(query: "Paracetamol")
        sut.add(query: "Batuk")

        #expect(sut.items.first?.query == "Batuk")
        #expect(sut.items.count == 2)
    }

    @Test("Query kosong atau whitespace saja tidak ditambahkan")
    func add_ignoresEmptyQuery() {
        let sut = makeSUT()
        sut.add(query: "   ")
        #expect(sut.items.isEmpty)
    }

    @Test("Query yang sudah ada dipindah ke depan, bukan duplikat")
    func add_deduplicatesExistingQuery() {
        let sut = makeSUT()
        sut.add(query: "Tolak")
        sut.add(query: "Batuk")
        sut.add(query: "tolak") // beda kapitalisasi harus dianggap sama

        #expect(sut.items.count == 2)
        #expect(sut.items.first?.query == "tolak")
    }

    @Test("Riwayat dibatasi maksimal 10 item")
    func add_capsAtMaxItems() {
        let sut = makeSUT()
        for i in 1...12 {
            sut.add(query: "query-\(i)")
        }
        #expect(sut.items.count == 10)
        #expect(sut.items.first?.query == "query-12")
    }

    @Test("Remove menghapus item spesifik")
    func remove_deletesTargetItem() {
        let sut = makeSUT()
        sut.add(query: "Paracetamol")
        sut.add(query: "Batuk")

        let target = sut.items.first { $0.query == "Batuk" }!
        sut.remove(target)

        #expect(sut.items.count == 1)
        #expect(sut.items.first?.query == "Paracetamol")
    }
}
