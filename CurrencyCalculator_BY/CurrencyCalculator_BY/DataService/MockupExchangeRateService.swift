//
//  MockupExchangeRateService.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/24/25.
//

import Foundation

class MockupExchangeRateService: ExchangeRateProtocol {
    func fetchExchangeRates(completion: @escaping (Result<[ExchangeRate], any Error>) -> Void) {
        DispatchQueue.main.async {
            completion(.success(self.createMockExchangeRates()))
        }
    }
    
    private func createMockExchangeRates() -> [ExchangeRate] {
            return [
                ExchangeRate(currencyCode: "USD", rate: 1.0, rateChangeStatus: .none),
                ExchangeRate(currencyCode: "AED", rate: 3.6725, rateChangeStatus: .up),
                ExchangeRate(currencyCode: "AFN", rate: 71.549598, rateChangeStatus: .down),
                ExchangeRate(currencyCode: "ALL", rate: 86.51252, rateChangeStatus: .up),
                ExchangeRate(currencyCode: "AMD", rate: 390.356758, rateChangeStatus: .down),
                ExchangeRate(currencyCode: "ANG", rate: 1.79, rateChangeStatus: .none),
                ExchangeRate(currencyCode: "AOA", rate: 919.42869, rateChangeStatus: .up),
                ExchangeRate(currencyCode: "ARS", rate: 1122.5, rateChangeStatus: .down),
                ExchangeRate(currencyCode: "AUD", rate: 1.565825, rateChangeStatus: .up),
                ExchangeRate(currencyCode: "AWG", rate: 1.79, rateChangeStatus: .none)
                // 필요한 만큼 더 추가 가능 일부만 확인
            ]
        }
    
}
