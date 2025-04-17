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
}
