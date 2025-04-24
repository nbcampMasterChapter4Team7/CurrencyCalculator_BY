//
//  RateChangeStatus.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/24/25.
//

import Foundation

enum RateChangeStatus {
    case up
    case down
    case none
    
    var icon: String {
        switch self {
        case .up:
            return "⬆️"
        case .down:
            return "⬇️"
        case .none:
            return ""
        }
    }
}
