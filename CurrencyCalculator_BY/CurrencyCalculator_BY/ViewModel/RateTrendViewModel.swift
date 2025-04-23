//
//  RateTrendViewModel.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/23/25.
//  상승, 하락을 계산하는 비즈니스 로직

import Foundation

// ===== ViewModel의 상태 정의 =====
struct ViewModelState {
    var updatedRates: [RateTrendViewModel] = []
}

// ===== ViewModel의 액션 정의 =====
enum ViewModelAction {
    case updateRates
}


struct RateTrendViewModel: ViewModelProtocol {
    typealias Action = ViewModelAction
    typealias State = ViewModelState
    
    // ===== 액션과 상태 =====
    var action: ((Action) -> Void)?
    var state: State = ViewModelState()
    
    let currency: String
    let rate: Double
    let previousRate: Double
    
    // ===== 상승 여부를 판단하는 계산 프로퍼티 =====
    var isRising: Bool {
        return rate > previousRate
    }
    
    // ===== Core Data에서 이전 환율 데이터를 가져오는 메서드 =====
    static func fetchPreviousRates() -> [String: Double] {
        guard let previousRates = CoreDataService.shared.fetchPreviousExchangeRates() else { return [:] }
        var ratesDict: [String: Double] = [:]
        previousRates.forEach { ratesDict[$0.currencyCode ?? ""] = $0.rate }
        return ratesDict
    }
    
    
    // ===== 새 데이터를 비교하고 상태를 업데이트하는 메서드 수정 =====
    static func compareAndUpdateRates(newRates: [RateTrendViewModel], nextUpdate: Date) -> [RateTrendViewModel] {
        let previousRates = fetchPreviousRates()
        var updatedViewModels: [RateTrendViewModel] = []

        for newRate in newRates {
            let previousRate = previousRates[newRate.currency] ?? 0.0
            let difference = abs(newRate.rate - previousRate)

            // 아이콘 표시 기준 수정
            if difference > 0.01 {
                let viewModel = RateTrendViewModel(
                    currency: newRate.currency,
                    rate: newRate.rate,
                    previousRate: previousRate
                )
                updatedViewModels.append(viewModel)
            } else {
                // 아이콘을 표시하지 않을 때 여백 처리
                var viewModel = RateTrendViewModel(
                    currency: newRate.currency,
                    rate: newRate.rate,
                    previousRate: previousRate
                )
                viewModel.state.updatedRates.append(viewModel)
            }
        }

        // ===== Core Data에 새 데이터를 저장 =====
        saveNewRatesToCoreData(newRates: newRates, nextUpdate: nextUpdate)
        
        return updatedViewModels
    }
    
    // ===== Core Data에 새 데이터를 저장하는 메서드 수정 =====
    static func saveNewRatesToCoreData(newRates: [RateTrendViewModel], nextUpdate: Date) {
        newRates.forEach { rate in
            _ = CoreDataService.shared.savePreviousExchangeRate(currencyCode: rate.currency, rate: rate.rate, lastUpdate: Date(), nextUpdate: nextUpdate)
        }
    }
}
