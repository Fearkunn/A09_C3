//
//  PantauanModel.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 15/07/26.
//
import Foundation
import SwiftData

@Model
final class PantauanModel {
    @Attribute(.unique) var id: UUID
    var pantauanDate: Date
    var pantauanBody: String
    var pantauanCreatedAt: Date
    var pantauanUpdatedAt: Date?
    
    init(pantauanDate: Date, pantauanBody: String) {
        self.id = UUID()
        self.pantauanDate = pantauanDate
        self.pantauanBody = pantauanBody
        self.pantauanCreatedAt = .now
        self.pantauanUpdatedAt = nil
    }
}
