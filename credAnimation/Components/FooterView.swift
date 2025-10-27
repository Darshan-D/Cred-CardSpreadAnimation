//
//  FooterView.swift
//  credAnimation
//
//  Created by Darshan Dodia on 17/07/25.
//

import SwiftUI

/// The footer view displaying total cards and a button to add more card
struct FooterView: View {
    
    let cards: [CardInfo]

    var body: some View {
        HStack {
            Text("ALL (\(cards.count))")
                .font(.caption.bold())
                .foregroundColor(.white)
            Spacer()
            Button {
                print("Add more cards")
            } label: {
                Image(systemName: "plus")
                    .tint(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
        .background(Color(.black))
    }
}

//#Preview {
//    FooterView(cards: sampleCards)
//}
