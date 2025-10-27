# Cred-CardSpreadAnimation
Mimics the credit card spread animation from the CRED App.

---

# SwiftUI Card Deck Animation 💳✨

[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-orange?style=for-the-badge&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue?style=for-the-badge)](https://www.apple.com/ios/)

Ever seen a slick, buttery-smooth animation in an app and think, "How on earth did they do that?" This repository is your chance to build one of those animations yourself.

This project is a deep dive into creating a beautiful, interactive, and fully functional card deck animation, inspired by popular finance app CRED. Drag a stack of cards, watch them gracefully spread into a list, and then seamlessly transition into a fully scrollable, interactive view.

**If you find this project helpful, please give it a ⭐️ to show your support!**

---

## ✨ Features

*   **Interactive Drag Gesture:** A fluid, physics-based drag that feels connected to your finger.
*   **Dynamic Card Stack:** Cards are stacked with a satisfying sense of depth and perspective.
*   **Seamless Transition:** A "secretive" and magical transition from an animated preview to a fully functional `ScrollView`. No jarring pops or pushes.
*   **Clean & Reusable:** The code is separated into logical components (`DraggableCardStackView`, `ExpandedCardListView`, `CardView`, etc.) for easy understanding and reuse.
*   **Heavily Commented:** Every complex piece of logic is explained, from the state management to the "secret" behind the seamless transition.

## 🎬 Demo

https://youtu.be/D4nyYXyJoEs

---

## 🧠 The Core Concepts Explained

This animation isn't black magic! It's built on three core SwiftUI principles that are demystified in the code:

1.  **State-Driven UI (`@State`)**
    We use a few key state variables to control every phase of the animation. One for the raw drag gesture, one for the "master switch" (stacked vs. spread), and one to trigger our secret weapon...

2.  **Linear Interpolation (`lerp`)**
    We use a tiny bit of high-school math to calculate the `offset` and `scale` of each card as it moves between its start and end positions. This is what gives the animation its fluid, non-linear feel. The code breaks down how to turn a messy drag gesture into a clean `progress` value from 0.0 to 1.0.

3.  **The Illusion: View Swapping**
    Here's the secret sauce! Instead of trying to make our animating `ZStack` scrollable (which is a world of pain), we perform a classic sleight-of-hand. While the user is distracted by the pretty spread animation, we overlay a completely separate, simple `ScrollView` on top. The timing is key to making this transition invisible and magical.

---

## 🚀 How to Use

Getting started is as simple as cloning the repo and running it in Xcode.

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Darshan-D/Cred-CardSpreadAnimation.git
    ```

2.  **Open in Xcode:**
    Open the `.xcodeproj` file and run the project on a simulator or a physical device.

3.  **Explore the Code:**
    *   `DraggableCardStackView.swift`: This is the heart of the project. It contains all the state management, gesture handling, and animation logic.
    *   `ExpandedCardListView.swift`: A simple, reusable view that displays the cards in a scrollable list.
    *   `CardView.swift`: The customizable view for a single card.
    *   `Configuration.swift`: All the magic numbers (offsets, spacings, delays) are neatly organized here for you to tweak and experiment with!

---

## 🔧 Customization

It's easy to adapt this to your own project!

*   **Change the Data:** Modify the `CardInfo` struct and the `sampleCards` array to use your own data model.
*   **Style the Cards:** The `CardView.swift` file is where all the UI for a single card lives. Go wild with your own designs!
*   **Tune the Animation:** Want a bouncier spring? A faster transition? Just adjust the values in the `Configuration` struct inside `DraggableCardStackView`.

```swift
/// A nested struct to hold all tunable constants for easy modification.
private struct Configuration {
    static let stackedYOffset: CGFloat = 12
    static let cardViewHeight: CGFloat = 190
    static let listSpacing: CGFloat = 15
    static let stackedScaleReduction: CGFloat = 0.05
    static let transitionDelay: Double = 0.35 // <-- The magic delay!
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.7) // <-- The physics!
}
