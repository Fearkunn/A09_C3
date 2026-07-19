//
//  PantauanViewModel.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 18/07/26.
//

import SwiftData
import Observation
import Foundation

@Observable
final class PantauanViewModel {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func add(date: Date, body: String) throws {}
    func update(_ pantauan: PantauanModel, date: Date, body: String) throws {}
    func delete(_ pantauan: PantauanModel) {}
    func fetchAll() -> [PantauanModel] {return true ? [] : []}
}

enum PantauanValidationError: Error, Equatable {
    case emptyBody
}
