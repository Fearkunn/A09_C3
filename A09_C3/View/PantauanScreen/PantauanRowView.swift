//
//  PantauanRowView.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 19/07/26.
//

import SwiftUI

struct PantauanRowView: View {
    let pantauan: PantauanModel
    
    private var formattedDate: String {
        pantauan.pantauanDate.formatted(
            .dateTime
                .day()
                .month(.wide)
                .year()
                .locale(Locale(identifier: "id_ID"))
        )
    }
    
    var body: some View {
        HStack {
            Text(formattedDate)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
            .ignoresSafeArea()
        PantauanRowView(pantauan: PantauanModel(pantauanDate: .now, pantauanBody: "Sakit tenggorokan, batuk-batuk"))
            .padding(.horizontal, 20)
    }
}

