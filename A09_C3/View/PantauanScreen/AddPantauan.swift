//
//  AddPantauan.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI
import SwiftData

struct AddPantauan: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var pantauanDate: Date = .now
    @State private var pantauanBody: String = ""

    var body: some View {
        AddModal(
            title: "Pantauan Baru",
            onClose: { dismiss() },
            onSave: {
                let pantauan = PantauanModel(
                    pantauanDate: pantauanDate,
                    pantauanBody: pantauanBody
                )
                modelContext.insert(pantauan)
                dismiss()
            }
        ) {
            Section {
                DatePicker(
                    "Tanggal pantauan",
                    selection: $pantauanDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
            }

            Section {
                TextField(
                    "Catatan",
                    text: $pantauanBody,
                    prompt: Text("Ketik atau ketuk ikon mikrofon untuk berbicara"),
                    axis: .vertical
                )
                .lineLimit(8...40)
            }
        }
    }
}

#Preview {
    AddPantauan()
        .modelContainer(for: PantauanModel.self, inMemory: true)
}
