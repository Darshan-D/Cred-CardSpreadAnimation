//
//  CardInfo.swift
//  credAnimation
//
//  Created by Darshan Dodia on 24/06/25.
//

import SwiftUI

struct CardInfo: Identifiable {
    let id = UUID()
    var name: String
    var last4Digits: String
    var amount: Double
    var sinceDate: String
    var color: Color
    var bankName: String
    var cardNetwork: String
}

let sampleCards: [CardInfo] = [
    CardInfo(name: "TED MOSBY",
             last4Digits: "6431",
             amount: 1234.50,
             sinceDate: "20 MAY",
             color: .gray,
             bankName: "HDFC Bank",
             cardNetwork: "VISA"),
    CardInfo(name: "JIM HALPERT",
             last4Digits: "3495",
             amount: 0.00,
             sinceDate: "22 MAY",
             color: .blue,
             bankName: "ICICI Bank",
             cardNetwork: "MASTERCARD"),
    CardInfo(name: "CHANDLER BING",
             last4Digits: "9599",
             amount: 61613.00,
             sinceDate: "23 MAY",
             color: .green,
             bankName: "SBI Bank",
             cardNetwork: "RUPAY"),
    CardInfo(name: "WALTER WHITE",
             last4Digits: "1111",
             amount: 100.00,
             sinceDate: "15 MAY",
             color: .purple,
             bankName: "TATA NEU Card",
             cardNetwork: "RUPAY"),
    CardInfo(name: "SHELDON COOPER",
             last4Digits: "2222",
             amount: 250.00,
             sinceDate: "10 MAY",
             color: .orange,
             bankName: "AMEX",
             cardNetwork: "DINNER CLUB"),
]
