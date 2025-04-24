//
//  CaculatorViewModel.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  환율 계산기 화면의 비즈니스 로직을 처리하는 뷰 모델
//  데이터 변환과 UI 업데이트를 담당

import Foundation

// ===== CalculatorViewModel 클래스 정의 =====
final class CalculatorViewModel: ViewModelProtocol {
    enum Action {
        case updateResult(String)
    }
    
    struct State {
        var resultText: String
    }
    
    var action: ((Action) -> Void)?
    var state = State(resultText: "계산 결과가 여기에 표시됩니다")
    var exchangeRate: Double = 0.0
    var currency: String = "" /// 통화 코드를 저장할 속성 추가
    
    // ===== 환율 계산 메서드 =====
    func calculateConvertedAmount(amount: String) {
        guard !amount.isEmpty else {
            action?(.updateResult("금액을 입력해주세요"))
            return
        }
        
        guard let amountValue = Double(amount) else {
            action?(.updateResult("올바른 숫자를 입력해주세요"))
            return
        }
        
        let convertedAmount = (amountValue * exchangeRate).rounded(toPlaces: 2)
        /// 결과값 형식 수정 (통화 기호 포함)
        action?(.updateResult("$\(String(format: "%.2f", amountValue)) → \(convertedAmount) \(currency)"))
    }
}
