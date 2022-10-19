//
//  Rate.swift
//  CryptoInformer
//
//  Created by Artyom Beldeiko on 19.10.22.
//

import Foundation

struct Rate: Codable {
    let success: Bool
    let terms, privacy: String
    let timestamp: Int
    let target: String
    let rates: [String: Double]
}
