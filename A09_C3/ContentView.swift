//
//  ContentView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 14/07/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("A09_C3")
                    .font(.largeTitle)
                    .bold()
                
                Text("SwiftData berhasil dikonfigurasi.")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [PantauanModel.self, Obat.self], inMemory: true)}
