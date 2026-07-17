//
//  ScreenHeader.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 17/07/26.
//

import SwiftUI

struct ScreenHeader: View {
    var title: String
    let addAction: () -> Void
    
    func indonesianText(_ text: String) -> AttributedString {
        var label = AttributedString(text)
        label.setAttributes(AttributeContainer([.accessibilitySpeechLanguage: "id_ID"]))
        return label
    }
    
    var body: some View {
        HStack {
            Text(indonesianText(title))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: addAction) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(.cyan))
            }
            .accessibilityLabel(Text(indonesianText("Tambah \(title)")))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
            .ignoresSafeArea()
        VStack {
            ScreenHeader(title: "Obat") {}
            Spacer()
        }
    }
}
