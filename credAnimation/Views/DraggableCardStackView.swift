//
//  DraggableCardStackView.swift
//  credAnimation
//
//  Created by Darshan Dodia on 24/06/25.
//

import SwiftUI

struct DraggableCardStackView: View {

    // MARK: - State Properties

    /// Card data
    @State private var cards: [CardInfo] = sampleCards

    /// Tracks the user's drag distance. This directly drives the interactive part of the animation.
    @State private var dragOffset: CGSize = .zero

    /// A boolean that controls the target state of the animation (stacked vs. spread).
    /// This is the primary driver for the spring animations in `calculateYOffset` and `calculateScale`.
    @State private var isSpreadForAnimation: Bool = false

    /// A boolean that triggers the presentation of the fully scrollable `ExpandedCardListView`.
    @State private var showExpandedListView: Bool = false

    /// A computed property to determine the drag distance needed to trigger a state change.
    private var dragStateChangeThreshold: CGFloat {
        Configuration.cardViewHeight * 0.5
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(card: cards.first!)

            Spacer()

            // The main ZStack contains the animating cards and, when triggered,
            // overlays the fully scrollable list on top for a seamless transition.
            ZStack {
                animatingCardsLayer

                if showExpandedListView {
                    ExpandedCardListView(isPresented: $showExpandedListView, cards: self.cards)
                        .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                        .zIndex(10)
                }
            }

            Spacer()

            FooterView(cards: self.cards)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $showExpandedListView,
                         onDismiss: handleDismissalOfExpandedList) {
            ExpandedCardListView(isPresented: $showExpandedListView, cards: self.cards)
        }
    }

    // MARK: - UI Components

    /// The ZStack of cards that animates based on drag and spread state.
    private var animatingCardsLayer: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { (stackIndex, card) in
                CardView(card: card,
                         // A card is considered "fully visible" (showing all details) if it's the top one,
                         // or if the whole stack is in the process of spreading.
                         isFullyVisible: isSpreadForAnimation || (stackIndex == 0 && !isSpreadForAnimation)
                )
                .zIndex(Double(cards.count - stackIndex)) // Higher index cards are visually behind
                .scaleEffect(calculateScale(for: stackIndex, dragOffsetY: dragOffset.height))
                .offset(x: 0, y: calculateYOffset(for: stackIndex, dragOffsetY: dragOffset.height))
                // These animations ensure smooth transitions when the state variables change.
                .animation(Configuration.springAnimation, value: isSpreadForAnimation)
                .animation(Configuration.springAnimation, value: dragOffset)
            }
        }
        .gesture(dragGesture)
    }

    // MARK: - Gesture

    /// The main drag gesture that controls the animation and presentation logic.
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 5)
            .onChanged { value in
                // Don't allow dragging if the full list is already shown.
                guard !showExpandedListView else {
                    return
                }

                self.dragOffset = value.translation
            }
            .onEnded { value in
                guard !showExpandedListView else {
                    return
                }

                let dragDistance = value.translation.height

                // If the user dragged upwards past the threshold
                if dragDistance < -dragStateChangeThreshold {

                    // 1. Trigger the animation to the "spread" state.
                    self.isSpreadForAnimation = true
                    
                    // 2. Schedule the appearance of the full-screen scrollable list.
                    //    This delay allows the user to see the spread animation before
                    //    the new view appears, creating a seamless transition.
                    DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.transitionDelay) {
                        if self.isSpreadForAnimation {
                            self.showExpandedListView = true
                        }
                    }
                }
                
                // 3. Always animate the drag offset back to zero to complete the gesture.
                //    The cards will snap to their final stacked or spread position.
                withAnimation(Configuration.springAnimation) {
                    self.dragOffset = .zero
                }
            }
    }
    
    // MARK: - Animation Calculation Logic

    /// Calculates the vertical offset (Y position) for a given card.
    /// - Parameters:
    ///   - stackIndex: The index of the card in the `cards` array (0 is the top card).
    ///   - dragOffsetY: The current vertical drag distance from the user's gesture.
    /// - Returns: The calculated `CGFloat` for the `.offset()` modifier.
    private func calculateYOffset(for stackIndex: Int, dragOffsetY: CGFloat) -> CGFloat {
        // The top card (index 0) moves directly with the user's finger for immediate feedback.
        if stackIndex == 0 {
            return dragOffsetY
        }
        
        // Define the two final positions for the card: fully stacked and fully spread.
        let yForStacked = CGFloat(stackIndex) * Configuration.stackedYOffset
        let yForSpreadList = CGFloat(stackIndex) * (Configuration.cardViewHeight + Configuration.listSpacing)
        
        // Get the current progress (0.0 to 1.0) of the transition.
        let transitionProgress = getTransitionProgress(for: dragOffsetY)
        
        // Use linear interpolation to find the card's current position between the two final states.
        // Formula: start + (end - start) * progress
        return yForStacked + (yForSpreadList - yForStacked) * transitionProgress
    }

    /// Calculates the scale factor for a given card.
    /// - Parameters:
    ///   - stackIndex: The index of the card in the `cards` array (0 is the top card).
    ///   - dragOffsetY: The current vertical drag distance from the user's gesture.
    /// - Returns: The calculated `CGFloat` for the `.scaleEffect()` modifier.
    private func calculateScale(for stackIndex: Int, dragOffsetY: CGFloat) -> CGFloat {
        // The top card is always at full scale.
        if stackIndex == 0 {
            return 1.0
        }

        // Define the two final scales for the card.
        let scaleWhenStacked = 1.0 - (CGFloat(stackIndex) * Configuration.stackedScaleReduction)
        let scaleWhenSpreadList = 1.0 // All cards are full scale when spread.

        // Get the current progress of the transition.
        let transitionProgress = getTransitionProgress(for: dragOffsetY)
        
        // Interpolate between the two scale values.
        // Formula: start + (end - start) * progress
        let targetScale = scaleWhenStacked + (scaleWhenSpreadList - scaleWhenStacked) * transitionProgress
        
        // Ensure the card doesn't become too small.
        return max(0.7, targetScale)
    }
    
    /// Calculates the current progress of the spread/stack animation, from 0.0 (stacked) to 1.0 (spread).
    /// This function clamps the value between 0 and 1.
    private func getTransitionProgress(for dragOffsetY: CGFloat) -> CGFloat {
        let transitionSensitivity = Configuration.cardViewHeight // How much drag completes the transition.
        
        if isSpreadForAnimation {
            // When already spread, a downward drag (positive offsetY) decreases progress back to 0.
            // We subtract from 1 to invert the logic.
            return 1.0 - min(1.0, max(0, dragOffsetY / transitionSensitivity))
        } else {
            // When stacked, an upward drag (negative offsetY) increases progress towards 1.
            // We use `-dragOffsetY` to make the value positive.
            return min(1.0, max(0, -dragOffsetY / transitionSensitivity))
        }
    }

    // When ExpandedCardListView is dismissed (either by swipe or the 'Done' button),
    // we must reset the animation state of the underlying stack, causing it to
    // animate back to its stacked form.
    private func handleDismissalOfExpandedList() {
        self.isSpreadForAnimation = false
    }
}

//#Preview {
//    DraggableCardStackView()
//}

