//
//  CaculatorViewModel.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  환율 계산기 화면의 비즈니스 로직을 처리하는 뷰 모델
//  데이터 변환과 UI 업데이트를 담당

import Foundation

class CalculatorViewModel {
    var exchangeRate: Double = 0.0
    
    // ===== 환율 계산 메서드 =====
    func calculateConvertedAmount (amount: String) -> String? {
        guard !amount.isEmpty else {
            return "금액을 입력해주세요"
        }
        
        guard let amountValue = Double(amount) else {
            return "올바른 숫자를 입력해주세요"
        }
        
        let convertedAmount = (amountValue * exchangeRate).rouned(toPlaces: 2)
        return "\(convertedAmount)"
    }
}
