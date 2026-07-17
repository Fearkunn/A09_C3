
//
//  empty_state.swift
//  A09_C3
//
//  Created by Dina on 15/07/26.
//

import SwiftUI

struct KonsulEmptyState: View {
    
    @State private var showModal = false
    
    func indonesianText(_ text: String) -> AttributedString {
        var label = AttributedString(text)
        label.setAttributes(AttributeContainer([.accessibilitySpeechLanguage: "id_ID"]))
        return label
    }
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var isAccessibilitySize: Bool {
        dynamicTypeSize.isAccessibilitySize
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                    .ignoresSafeArea()
            VStack {
                HStack {
                    Text(indonesianText("Konsultasi"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action:  {
                        showModal = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle().fill(.cyan)
                            )
                    }
                    .offset(y: -50)
                    .accessibilityLabel(Text(indonesianText("Tombol Tambah")))
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "pencil.and.list.clipboard")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text(indonesianText("Tidak ada data"))
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(isAccessibilitySize ? .center : .leading)
                    
                    
                    Text(indonesianText("Ketuk tombol tambah untuk memulai"))
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(isAccessibilitySize ? .center : .leading)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showModal) {
                    AddKonsul()
                }
            
    }
}

#Preview {
    KonsulEmptyState()
}
