//
//  ExchangeRate.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/24/25.
//

import Foundation

struct ExchangeRate {
    let currencyCode: String
    let rate: Double
    let timestamp: Date
    var rateChangeStatus: RateChangeStatus = .none
    
    init(currencyCode: String, rate: Double, timestamp: Date = Date(), rateChangeStatus: RateChangeStatus = .none) {
        self.currencyCode = currencyCode
        self.rate = rate
        self.timestamp = timestamp
        self.rateChangeStatus = rateChangeStatus
    }
}
