//
//  empty_state.swift
//  A09_C3
//
//  Created by Dina on 15/07/26.
//

import SwiftUI

struct EmptyState: View {
    var body: some View {
        VStack {
            HStack {
                Text("Konsultasi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                
                Button(action: {
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding(.trailing, 20)
            Spacer()
            
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 70, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text("Tidak ada data")
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.top, 2)
            Spacer()
        }
    }
}

#Preview {
    EmptyState()
}
