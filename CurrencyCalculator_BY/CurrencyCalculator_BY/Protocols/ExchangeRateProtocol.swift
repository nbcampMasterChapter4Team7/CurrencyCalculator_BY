//
//  ExchangeRateProtocol.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/24/25.
//
import Foundation
protocol ExchangeRateProtocol {
    func fetchExchangeRates(completion: @escaping (Result<[ExchangeRate], Error>) -> Void)
}

