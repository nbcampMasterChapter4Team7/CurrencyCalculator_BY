//
//  ExchangeRateManager.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/24/25.
//

import Foundation
import CoreData
import UIKit

// 환율 정보를 관리하는 클래스
class ExchangeRateManager {
    
    // Core Data의 NSManagedObjectContext를 가져오는 프로퍼티
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 환율 정보를 업데이트하거나 새로 추가하는 메서드
    func updateExchangeRate(currencyCode: String, rate: Double, timestamp: Date) {
        // 특정 통화 코드를 가진 환율 정보를 가져오는 요청 생성
        let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            // 기존의 환율 정보를 가져옴
            let results = try context.fetch(fetchRequest)
            let exchangeRate: ExchangeRateEntity
            
            if let existingRate = results.first {
                // 기존 데이터가 있을 경우 업데이트
                exchangeRate = existingRate
                
                // 타임스탬프가 다를 경우에만 업데이트 진행
                if exchangeRate.timeStamp != timestamp {
                    exchangeRate.beforeRate = exchangeRate.nowRate
                    exchangeRate.nowRate = rate
                    exchangeRate.timeStamp = timestamp
                    print("\(timestamp)")
                }
            } else {
                // 새로운 데이터일 경우 새로 생성
                exchangeRate = ExchangeRateEntity(context: context)
                exchangeRate.currencyCode = currencyCode
                exchangeRate.beforeRate = rate
                exchangeRate.nowRate = rate
                exchangeRate.timeStamp = timestamp
            }
            
            // 변경 사항 저장
            try context.save()
        } catch {
            print("Error saving exchange rate: \(error)")
        }
    }
    
    // 특정 통화 코드의 환율 정보를 가져오는 메서드
    func getExchangeRate(for currencyCode: String) -> (beforeRate: Double, nowRate: Double)? {
        let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            // 요청 결과를 가져옴
            let results = try context.fetch(fetchRequest)
            if let rate = results.first {
                return (beforeRate: rate.beforeRate, nowRate: rate.nowRate)
            }
            return nil
        } catch {
            print("Error fetching exchange rate: \(error)")
            return nil
        }
    }
    
    // 모든 환율 정보를 가져오는 메서드
    func getAllExchangeRates() -> [(currencyCode: String, beforeRate: Double, nowRate: Double)] {
        let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
        
        do {
            // 모든 환율 정보를 가져옴
            let results = try context.fetch(fetchRequest)
            
            return results.map { rate in
                return (currencyCode: rate.currencyCode ?? "", beforeRate: rate.beforeRate, nowRate: rate.nowRate)
            }
        } catch {
            print("Error fetching exchange rate: \(error)")
            return []
        }
    }
    
    // 특정 통화 코드의 환율 변동 상태를 반환하는 메서드
    func getRateChangeStatus(for currncyCode: String) -> RateChangeStatus {
        guard let rates = getExchangeRate(for: currncyCode) else {
            return .none
        }
        
        // 현재 환율과 이전 환율의 차이를 계산
        let difference = rates.nowRate - rates.beforeRate
        if abs(difference) <= 0.01 {
            return .none
        }
        return difference > 0 ? .up : .down
    }
}
