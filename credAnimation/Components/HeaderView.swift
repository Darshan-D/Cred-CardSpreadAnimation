//
//  HeaderView.swift
//  credAnimation
//
//  Created by Darshan Dodia on 17/07/25.
//

import SwiftUI

/// The header view displaying the total recent spends.
struct HeaderView: View {
    let card: CardInfo

    var body: some View {
        VStack {
            Text("RECENT SPENDS")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Displays the amount from the first card in the data array.
            Text("₹\(String(format: "%.2f", card.amount))")
                .font(.largeTitle.weight(.bold))
            Button {
                print("Showing Statement")
            } label: {
                HStack {
                    Text("switch to statement")
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .padding(.top)
    }
}
//
//#Preview {
//    HeaderView(card: sampleCards[0])
//}
