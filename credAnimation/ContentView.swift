//import SwiftUI
//
//struct ExpandedCardListView: View {
//    @Binding var isPresented: Bool // To control the presentation (from .fullScreenCover)
//    let cards: [CardInfo]
//    let cardViewHeight: CGFloat = 190 // Match your CardView height
//    let listSpacing: CGFloat = 15     // Match your listSpacing
//
//    var body: some View {
//        NavigationView { // Optional: if you want a nav bar for a title or dismiss button
//            ScrollView {
//                VStack(spacing: listSpacing) {
//                    ForEach(cards) { card in
//                        // In this list, every card is "fully visible"
//                        CardView(card: card, isFullyVisible: true)
//                    }
//                }
//                .padding() // Add some padding around the list
//            }
//            .navigationTitle("All Cards")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        isPresented = false // Dismiss the fullScreenCover
//                    }
//                }
//            }
//        }
//    }
//}

//import SwiftUI
//
//// CardInfo (from your code)
//struct CardInfo: Identifiable {
//    let id = UUID()
//    var name: String
//    var last4Digits: String
//    var amount: Double
//    var sinceDate: String
//    var color: Color
//    var cardArtPattern: String
//}
//
//// sampleCards (from your code - ensure this is the order for the initial stack)
//let sampleCards: [CardInfo] = [
//    CardInfo(name: "ANOTHER CARD", last4Digits: "6431", amount: 1234.50, sinceDate: "20 MAY", color: .gray, cardArtPattern: "creditcard.fill"),
//    CardInfo(name: "DARSHAN DODIA", last4Digits: "3495", amount: 0.00, sinceDate: "22 MAY", color: .blue.opacity(0.9), cardArtPattern: "creditcard.fill"),
//    CardInfo(name: "DARSHAN", last4Digits: "9599", amount: 61613.00, sinceDate: "23 MAY", color: .blue, cardArtPattern: "creditcard.fill"),
//    // Add more for testing if needed
//    CardInfo(name: "EXTRA GREEN", last4Digits: "1111", amount: 100.00, sinceDate: "15 MAY", color: .green, cardArtPattern: "creditcard.fill"),
//    CardInfo(name: "EXTRA ORANGE", last4Digits: "2222", amount: 250.00, sinceDate: "10 MAY", color: .orange, cardArtPattern: "creditcard.fill"),
//]

// CardView (from your code, with isTopCard -> isFullyVisible)
//struct CardView: View {
//    let card: CardInfo
//    let isFullyVisible: Bool // Changed from isTopCard for clarity
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            RoundedRectangle(cornerRadius: 15)
//                .fill(card.color)
//                .overlay(
//                    Image(systemName: card.cardArtPattern)
//                        .resizable().scaledToFit().frame(width: 80, height: 80)
//                        .foregroundColor(.white.opacity(0.1)).rotationEffect(.degrees(-30))
//                        .offset(x: 80, y: 20),
//                    alignment: .center
//                )
//                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
//
//            VStack(alignment: .leading, spacing: 10) {
//                HStack {
//                    Text("HDFC BANK").font(.caption.weight(.bold)).foregroundColor(.white)
//                    Spacer()
//                    if card.amount > 0 || isFullyVisible {
//                         Text("₹\(String(format: "%.2f", card.amount))")
//                            .font(.headline).foregroundColor(.white)
//                    } else if card.amount == 0 && isFullyVisible {
//                        Text("₹0.00").font(.headline).foregroundColor(.white)
//                    } else if card.amount == 0 && !isFullyVisible {
//                        Text("₹0.00").font(.headline).foregroundColor(.white.opacity(0.7))
//                    }
//                }
//                if card.amount > 0 || isFullyVisible {
//                    Text("SPENT SINCE \(card.sinceDate.uppercased())")
//                        .font(.caption2).foregroundColor(.white.opacity(0.8))
//                }
//                Spacer()
//                HStack {
//                    Image(systemName: "simcard.fill").font(.title).foregroundColor(.yellow.opacity(0.8))
//                    Spacer()
//                    if isFullyVisible {
//                        Button(card.amount > 0 ? "Pay more" : "Pay dues") {
//                            print("\(card.amount > 0 ? "Pay more" : "Pay dues") for \(card.name)")
//                        }
//                        .padding(.horizontal, 20).padding(.vertical, 8)
//                        .background(Color.white).foregroundColor(card.color).cornerRadius(8)
//                    }
//                }
//                .padding(.bottom, 5)
//                HStack {
//                    Text("VISA").font(.caption.weight(.semibold)).foregroundColor(.white)
//                    Text("•••• \(card.last4Digits)").font(.caption).foregroundColor(.white)
//                    Spacer()
//                }
//                Text(card.name).font(.subheadline.weight(.medium)).foregroundColor(.white)
//            }
//            .padding()
//        }
//        .frame(width: 300, height: 190)
//    }
//}


//struct DraggableCardStackView: View {
//    @State private var cards: [CardInfo] = sampleCards
//    @State private var dragOffset: CGSize = .zero
//    @State private var isSpreadForAnimation: Bool = false // Internal state for animation
//    @State private var showExpandedListView: Bool = false // State to trigger .fullScreenCover
//
//    // Configuration from your provided code
//    let stackedOffset: CGFloat = 12
//    let cardViewHeight: CGFloat = 190
//    let listSpacing: CGFloat = 15
//    let scaleReductionFactor: CGFloat = 0.05
//    var dragStateChangeThreshold: CGFloat { cardViewHeight * 0.5 }
//
//    var body: some View {
//        VStack {
//            // Header
//            VStack {
//                Text("RECENT SPENDS")
//                    .font(.caption).foregroundColor(.gray)
//                Text("₹\(String(format: "%.2f", cards.first?.amount ?? 0.0))")
//                    .font(.largeTitle.weight(.bold))
//                Button { /* Action */ } label: {
//                    HStack { Text("switch to statement"); Image(systemName: "arrow.left.arrow.right.circle.fill") }
//                    .font(.caption).padding(.horizontal, 12).padding(.vertical, 6)
//                    .background(Color.black).foregroundColor(.white).clipShape(Capsule())
//                }
//            }
//            .padding(.top)
//
//            Spacer()
//
//            ZStack {
//                ForEach(Array(cards.enumerated()), id: \.element.id) { (stackIndex, card) in
//                    CardView(card: card,
//                             // isFullyVisible is true if it's the top card OR if the animation state is "spread"
//                             isFullyVisible: isSpreadForAnimation || (stackIndex == 0 && !isSpreadForAnimation)
//                    )
//                    .zIndex(Double(cards.count - stackIndex))
//                    .scaleEffect(calculateScale(for: stackIndex, dragOffsetY: dragOffset.height))
//                    .offset(x: 0, y: calculateYOffset(for: stackIndex, dragOffsetY: dragOffset.height))
//                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSpreadForAnimation)
//                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: dragOffset)
//                }
//            }
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        // Prevent dragging if the expanded list is already shown or about to be shown
//                        guard !showExpandedListView else { return }
//                        self.dragOffset = value.translation
//                    }
//                    .onEnded { value in
//                        guard !showExpandedListView else { return } // Prevent re-triggering
//                        let dragDistance = value.translation.height
//                        
//                        // Decide if we should show the expanded list
//                        if dragDistance < -dragStateChangeThreshold {
//                            if !self.isSpreadForAnimation { self.isSpreadForAnimation = true } // Trigger spread animation
//                            // After a short delay for the animation to play, show the full screen cover
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Adjust delay as needed
//                                self.showExpandedListView = true
//                            }
//                        } else { // Or if dragging down, ensure it's stacked
//                            if self.isSpreadForAnimation { self.isSpreadForAnimation = false }
//                        }
//                        // Always animate dragOffset back to zero
//                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
//                            self.dragOffset = .zero
//                        }
//                    }
//            )
//            
//            Spacer()
//
//            // Footer
//            HStack {
//                Text("ALL (\(cards.count))").font(.caption.bold()).padding(10)
//                    .background(Color.gray.opacity(0.2)).cornerRadius(8)
//                Spacer()
//                Button { } label: { Image(systemName: "plus").padding(10) }
//                    .background(Color.gray.opacity(0.2)).cornerRadius(8)
//            }
//            .padding()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemGray6))
//        .fullScreenCover(isPresented: $showExpandedListView) {
//            // When the cover is dismissed, ensure the animation state is reset
//            self.isSpreadForAnimation = false
//            // Potentially reset dragOffset again if needed, though it should be zero
//            // self.dragOffset = .zero
//        } content: {
//            ExpandedCardListView(isPresented: $showExpandedListView, cards: self.cards)
//        }
//    }
//
//    func calculateYOffset(for stackIndex: Int, dragOffsetY: CGFloat) -> CGFloat {
//        if stackIndex == 0 {
//            return dragOffsetY
//        }
//        let yForStacked = CGFloat(stackIndex) * stackedOffset
//        let yForSpreadList = CGFloat(stackIndex) * (cardViewHeight + listSpacing) // This defines the "spread" look
//        let transitionSensitivity = cardViewHeight * 1.0
//        var transitionProgress: CGFloat
//        if isSpreadForAnimation {
//            transitionProgress = 1.0 - min(1.0, max(0, dragOffsetY / transitionSensitivity))
//        } else {
//            transitionProgress = min(1.0, max(0, -dragOffsetY / transitionSensitivity))
//        }
//        if isSpreadForAnimation && dragOffsetY < -10 { transitionProgress = 1.0 }
//        else if !isSpreadForAnimation && dragOffsetY > 10 { transitionProgress = 0.0 }
//        return yForStacked + (yForSpreadList - yForStacked) * transitionProgress
//    }
//
//    func calculateScale(for stackIndex: Int, dragOffsetY: CGFloat) -> CGFloat {
//        if stackIndex == 0 { return 1.0 }
//        let scaleWhenStacked = 1.0 - (CGFloat(stackIndex) * scaleReductionFactor)
//        let scaleWhenSpreadList = 1.0 // All cards full scale in your "spread list" state
//        let transitionSensitivity = cardViewHeight * 1.0
//        var transitionProgress: CGFloat
//        if isSpreadForAnimation {
//            transitionProgress = 1.0 - min(1.0, max(0, dragOffsetY / transitionSensitivity))
//        } else {
//            transitionProgress = min(1.0, max(0, -dragOffsetY / transitionSensitivity))
//        }
//        if isSpreadForAnimation && dragOffsetY < -10 { transitionProgress = 1.0 }
//        else if !isSpreadForAnimation && dragOffsetY > 10 { transitionProgress = 0.0 }
//        let targetScale = scaleWhenStacked + (scaleWhenSpreadList - scaleWhenStacked) * transitionProgress
//        return max(0.7, targetScale)
//    }
//}

//struct DraggableCardStackView_Previews: PreviewProvider {
//    static var previews: some View {
//        DraggableCardStackView()
//    }
//}
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

// -- DD -- FINAL APPROACH

//
//struct DraggableCardStackView: View {
//    @State private var cards: [CardInfo] = sampleCards
//    @State private var dragOffset: CGSize = .zero
//    @State private var isSpreadForAnimation: Bool = false // Internal state for animation
//    @State private var showExpandedListView: Bool = false // State to trigger .fullScreenCover
//
//    // Configuration from your provided code
//    let stackedOffset: CGFloat = 12
//    let cardViewHeight: CGFloat = 190
//    let listSpacing: CGFloat = 15
//    let scaleReductionFactor: CGFloat = 0.05
//    var dragStateChangeThreshold: CGFloat { cardViewHeight * 0.5 }
//
//    var body: some View {
//        VStack {
//            // Header
//            VStack {
//                Text("RECENT SPENDS")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text("₹\(String(format: "%.2f", cards.first?.amount ?? 0.0))")
//                    .font(.largeTitle.weight(.bold))
//                Button { /* Action */ } label: {
//                    HStack { Text("switch to statement"); Image(systemName: "arrow.left.arrow.right.circle.fill") }
//                        .font(.caption).padding(.horizontal, 12).padding(.vertical, 6)
//                        .background(Color.black).foregroundColor(.white).clipShape(Capsule())
//                }
//            }
//            .padding(.top)
//
//            Spacer()
//
//            ZStack {
//                ForEach(Array(cards.enumerated()), id: \.element.id) { (stackIndex, card) in
//                    CardView(card: card,
//                             // isFullyVisible is true if it's the top card OR if the animation state is "spread"
//                             isFullyVisible: isSpreadForAnimation || (stackIndex == 0 && !isSpreadForAnimation)
//                    )
//                    .zIndex(Double(cards.count - stackIndex))
//                    .scaleEffect(calculateScale(for: stackIndex, dragOffsetY: dragOffset.height))
//                    .offset(x: 0, y: calculateYOffset(for: stackIndex, dragOffsetY: dragOffset.height))
//                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSpreadForAnimation)
//                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: dragOffset)
//                }
//            }
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        self.dragOffset = value.translation
//                    }
//                    .onEnded { value in
//                        let dragDistance = value.translation.height
//
//                        // Decide if we should show the expanded list
//                        if dragDistance < -dragStateChangeThreshold {
//                            if !self.isSpreadForAnimation { self.isSpreadForAnimation = true } // Trigger spread animation
//                            // After a short delay for the animation to play, show the full screen cover
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Adjust delay as needed
//                                self.showExpandedListView = true
//                            }
//                        }
//                        // Always animate dragOffset back to zero
//                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
//                            self.dragOffset = .zero
//                        }
//                    }
//            )
//
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemGray6))
//        .fullScreenCover(isPresented: $showExpandedListView) {
//            self.isSpreadForAnimation = false
//        } content: {
//            ExpandedCardListView(isPresented: $showExpandedListView, cards: self.cards)
//        }
//    }
//
//    func calculateYOffset(for stackIndex: Int, dragOffsetY: CGFloat) -> CGFloat {
//        if stackIndex == 0 {
//            return dragOffsetY
//        }
//        let yForStacked = CGFloat(stackIndex) * stackedOffset
//        let yForSpreadList = CGFloat(stackIndex) * (cardViewHeight + listSpacing) // This defines the "spread" look
//        let transitionProgress = getTransitionProgress(for: dragOffsetY)
//        return yForStacked + (yForSpreadList - yForStacked) * transitionProgress
//    }
//
//    func calculateScale(for stackIndex: Int, dragOffsetY: CGFloat) -> CGFloat {
//        if stackIndex == 0 { return 1.0 }
//        let scaleWhenStacked = 1.0 - (CGFloat(stackIndex) * scaleReductionFactor)
//        let scaleWhenSpreadList = 1.0 // All cards full scale in your "spread list" state
//        let transitionProgress = getTransitionProgress(for: dragOffsetY)
//        let targetScale = scaleWhenStacked + (scaleWhenSpreadList - scaleWhenStacked) * transitionProgress
//        return max(0.7, targetScale)
//    }
//
//    func getTransitionProgress(for dragOffsetY: CGFloat) -> CGFloat {
//        if isSpreadForAnimation {
//            return 1.0 - min(1.0, max(0, dragOffsetY / cardViewHeight))
//        } else {
//            return min(1.0, max(0, -dragOffsetY / cardViewHeight))
//        }
//    }
//}
//
