//
//  CurrencyResult.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//

import Foundation

// ===== 서버에서 받아온 환율 정보를 담는 딕셔너리 =====
struct CurrencyResult: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUtc: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUtc: String
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUtc = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUtc = "time_next_update_utc"
        case baseCode = "base_code"
        case rates
    }
}
