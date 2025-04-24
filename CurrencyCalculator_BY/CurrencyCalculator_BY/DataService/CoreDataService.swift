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
    
    // 싱글턴 패턴+context 접근 관리(context는 항상 AppDelegate의 persistentContainer에서 가져옴)
    static let shared = CoreDataService()
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 데이터 불러오기 메서드(오늘 데이터 (isCurrent == true) 또는 어제 데이터 (false)만 가져옴)
    func fetchRates(isCurrent: Bool) -> [PreviousExchangeRate] {
        let request: NSFetchRequest<PreviousExchangeRate> = PreviousExchangeRate.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrent == %@", NSNumber(value: isCurrent))
        return (try? context.fetch(request)) ?? []
    }
    
    // (API에서 받아온 환율 데이터들을 저장/isCurrent == true이면 오늘, false면 어제로 구분)
    // 기존 데이터 일괄 삭제 → 새 데이터 저장 → UserDefaults에 업데이트 시간 저장
    func updateRatesCycle(rates: [String: Double], isCurrent: Bool, nextUpdate: Date) {
        
        let oldTodayRates = fetchRates(isCurrent: true)
        
        /// 1. 어제 데이터로 백업 (새로운 데이터가 오면 오늘로 덮어쓰기만 하고, 어제 데이터는 증발)
        oldTodayRates.forEach {
            let yesterday = PreviousExchangeRate(context: context)
            yesterday.currencyCode = $0.currencyCode
            yesterday.rate = $0.rate
            yesterday.isCurrent = false
        }
        
        /// 2. 기존 오늘 데이터만 삭제 (isCurrent == true)
        let request: NSFetchRequest<PreviousExchangeRate> = PreviousExchangeRate.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrent == true")
        let currentRates = (try? context.fetch(request)) ?? []
        currentRates.forEach { context.delete($0) }
        
        /// 3. 새 오늘 데이터 저장 (isCurrent = true)
        for (currencyCode, rate) in rates {
            let rateEntity = PreviousExchangeRate(context: context)
            rateEntity.currencyCode = currencyCode
            rateEntity.rate = rate
            rateEntity.isCurrent = true
        }
        
        /// 4. 업데이트 시간 저장
        UserDefaults.standard.set(nextUpdate, forKey: "nextUpdate")
        
        try? context.save()
    }
}
