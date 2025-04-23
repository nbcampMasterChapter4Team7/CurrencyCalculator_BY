//
//  RateTrendViewModel.swift
//  CurrencyCalculator_BY
//

import Foundation

struct RateTrendState {
    struct CurrencyRate {
        let currencyCode: String
        let rate: Double
        let trend: TrendDirection?
    }
    
    enum TrendDirection {
        case up
        case down
        case none
    }
    
    let currencyRates: [CurrencyRate]
}

class RateTrendViewModel: ViewModelProtocol {
    // 프로토콜 구현
    /// loadRates 액션을 트리거로 Core Data에서 오늘/어제 데이터를 불러오고 비교
    enum Action {
        case loadRates
    }
    
    typealias State = RateTrendState
    var action: ((Action) -> Void)?
    private(set) var state = RateTrendState(currencyRates: [])
    
    // init 초기화
    init() {
        self.action = { [weak self] action in
            switch action {
            case .loadRates:
                self?.loadRateComparison()
            }
        }
    }
    
    private func loadRateComparison() {
        /// 어제, 오늘의 환율 데이터를 CoreData에서 불러옴
        let currentRates = CoreDataService.shared.fetchRates(isCurrent: true)
        let previousRates = CoreDataService.shared.fetchRates(isCurrent: false)
        
        /// 어제 환율 데이터를 딕셔너리로 변환
        let previousDict = Dictionary(uniqueKeysWithValues: previousRates.map { ($0.currencyCode ?? "", $0.rate) })
        
        /// 오늘 환율 데이터를 순회하며 비교
        let result = currentRates.compactMap { current -> RateTrendState.CurrencyRate? in
            guard let code = current.currencyCode else { return nil }
            let newRate = current.rate
            guard let oldRate = previousDict[code] else {
                ///이전 데이터가 없는 경우, Trend 없이 반환하기
                return RateTrendState.CurrencyRate(currencyCode: code, rate: newRate, trend: nil)
            }
            
            /// abs(new - old) > 0.01이고, 이를 만족하면 .up 또는 .down, 아니면 .none으로 표시
            let diff = abs(newRate - oldRate)
            let trend: RateTrendState.TrendDirection? = {
                if diff <= 0.01 {
                    return RateTrendState.TrendDirection.none
                } else if newRate > oldRate {
                    return .up
                } else {
                    return .down
                }
            }()
            
            // 환율 코드, 새로운 환율, Trend 정보를 포함한 CurrencyRate
            return RateTrendState.CurrencyRate(currencyCode: code, rate: newRate, trend: trend)
        }
        
        // 상태를 업데이트하여 새로운 환율과 Trend를 저장
        self.state = RateTrendState(currencyRates: result)
        self.action?(.loadRates) // 상태 업데이트 알림 명시
    }
}
