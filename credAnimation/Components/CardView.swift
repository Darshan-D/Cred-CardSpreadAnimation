//
//  credAnimationApp.swift
//  credAnimation
//
//  Created by Darshan Dodia on 19/06/25.
//

import SwiftUI

struct CardView: View {
    let card: CardInfo
    let isFullyVisible: Bool
    let cardViewHeight: CGFloat = 190

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(card.color)
                .overlay(
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white.opacity(0.1))
                        .rotationEffect(.degrees(-30))
                        .offset(x: 80, y: 20),
                    alignment: .center
                )
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(card.bankName)
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("₹\(String(format: "%.2f", card.amount))")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                Text("SPENT SINCE \(card.sinceDate.uppercased())")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                HStack {
                    Image(systemName: "simcard.fill")
                        .font(.title)
                        .foregroundColor(.yellow.opacity(0.8))
                    Spacer()

                    if isFullyVisible {
                        Button("Pay dues") {
                            print("Paid Dues for \(card.name)")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .foregroundColor(card.color)
                        .cornerRadius(8)
                    }
                }
                .padding(.bottom, 5)
                
                HStack {
                    Text(card.cardNetwork)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white)
                    Text("•••• \(card.last4Digits)")
                        .font(.caption)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                Text(card.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(width: 300, height: cardViewHeight)
    }
}

//#Preview {
//    CardView(card: sampleCards[0], isFullyVisible: true)
//}
