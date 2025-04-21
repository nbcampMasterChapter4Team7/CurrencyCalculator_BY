//
//  Double.Extensions.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/21/25.
//

import UIKit

// ===== 소수점 반올림을 위한 extension =====
extension Double {
    func rouned(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
