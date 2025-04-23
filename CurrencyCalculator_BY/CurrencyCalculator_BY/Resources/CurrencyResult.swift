//
//  CurrencyResult.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//

import Foundation

// ===== 서버에서 받아온 환율 정보를 담는 딕셔너리 =====
struct CurrencyResult: Codable {
    let rates: [String: Double]
    let timeLastUpdateUtc: String
    let timeNextUpdateUtc: String
    
    enum CodingKeys: String, CodingKey {
        case timeLastUpdateUtc = "time_last_update_utc"
        case timeNextUpdateUtc = "time_next_update_utc"
        case rates
    }
    
}
