//
//  CoreDataService.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/23/25.
//  Lv 8. 환율 상승, 하락 계산을 위해 데이터를 저장
//

import CoreData
import UIKit

class CoreDataService {
    // ===== 싱글톤 패턴 적용 =====
    static let shared = CoreDataService()
    private init() {}

    // ===== Core Data 컨텍스트 접근 =====
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // ===== 데이터 저장 메서드 =====
    func savePreviousExchangeRate(currencyCode: String, rate: Double) -> Bool {
        let newRate = PreviousExchangeRate(context: context)
        newRate.currencyCode = currencyCode
        newRate.rate = rate

        do {
            try context.save()
            return true
        } catch {
            print("Failed to save previous exchange rate: \(error)")
            return false
        }
    }

    // ===== 데이터 불러오기 메서드 =====
    func fetchPreviousExchangeRates() -> [PreviousExchangeRate]? {
        let fetchRequest: NSFetchRequest<PreviousExchangeRate> = PreviousExchangeRate.fetchRequest()

        do {
            let previousRates = try context.fetch(fetchRequest)
            return previousRates
        } catch {
            print("Failed to fetch previous exchange rates: \(error)")
            return nil
        }
    }
}
