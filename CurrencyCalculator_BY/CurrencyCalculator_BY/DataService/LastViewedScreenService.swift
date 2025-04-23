//
//  LastViewedScreenService.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/23/25.
//

import Foundation
import CoreData
import UIKit

final class LastViewedScreenService {
    
    static let shared = LastViewedScreenService()  // 싱글톤 인스턴스 생성
    private init() {}  // 외부에서 인스턴스 생성 불가
    
    private var context: NSManagedObjectContext {
        // CoreData 컨텍스트 가져오기
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // 마지막 화면 정보 저장 메서드(기존 데이터 삭제 후 새로 저장)
    func saveLastViewedScreen(screenName: String, currencyCode: String?) {
        // 기존 데이터 삭제
        deleteLastViewedScreen()
        
        // 새로운 데이터 생성
        let newScreen = LastViewedScreen(context: context)
        newScreen.screenName = screenName
        newScreen.currencyCode = currencyCode
        
        do {
            try context.save()
        } catch {
            print("저장 실패: \(error.localizedDescription)")
        }
    }

    // 마지막 화면 정보 불러오기 메서드
    func fetchLastViewedScreen() -> (screenName: String, currencyCode: String?)? {
        let fetchRequest: NSFetchRequest<LastViewedScreen> = LastViewedScreen.fetchRequest()

        do {
            // 데이터를 불러와서 반환
            let results = try context.fetch(fetchRequest)
            if let lastViewed = results.first {
                return (lastViewed.screenName ?? "", lastViewed.currencyCode)
            }
        } catch {
            print("불러오기 실패: \(error.localizedDescription)")
        }
        return nil
    }
    
    // 마지막 화면 정보 삭제 메서드
    func deleteLastViewedScreen() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LastViewedScreen.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("삭제 실패: \(error.localizedDescription)")
        }
    }
}
