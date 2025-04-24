//
//  AppDelegate.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/16/25.
//  앱 생명 주기를 관리하는 파일로 앱 시작, 종료 시 필요한 설정과 초기화 담당

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyCalculator_BY")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved CoreData error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data 저장
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("CoreData 저장 실패: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
