//
//  ExpandedCardListView.swift
//  credAnimation
//
//  Created by Darshan Dodia on 24/06/25.
//

import SwiftUI

struct ExpandedCardListView: View {
    @Binding var isPresented: Bool
    let cards: [CardInfo]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Configuration.listSpacing) {
                    ForEach(cards) { card in
                        // In this list, every card is "fully visible"
                        CardView(card: card, isFullyVisible: true)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("All Cards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    ExpandedCardListView(isPresented: .constant(true), cards: sampleCards)
//}
