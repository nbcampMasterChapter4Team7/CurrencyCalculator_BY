//
//  SceneDelegate.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/24/25.
//  앱의 씬 생명주기 관리 및 마지막 화면 복원 처리

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // 앱이 실행될 때 호출되는 메서드 (앱이 백그라운드였다가 포그라운드로 돌아올 때도 포함)
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // UIWindow 생성 및 설정
        let window = UIWindow(windowScene: windowScene)

        // CoreData 컨테이너 및 마지막 화면 저장 서비스 준비
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let service = LastViewedScreenService(persistentContainer: container)

        // 기본 시작 화면: 환율 목록 화면
        let currencyVC = CurrencyViewController()
        let navVC = UINavigationController(rootViewController: currencyVC)

        // 마지막으로 봤던 화면 정보가 있다면 해당 화면으로 이동
        if let lastViewed = service.fetchLastViewedScreen() {
            switch lastViewed.screenName {
            case "CalculatorViewController":
                let calculatorVC = CalculatorViewController()
                calculatorVC.selectedCurrency = lastViewed.currencyCode
                navVC.pushViewController(calculatorVC, animated: false)
            default:
                break
            }
        }

        // 루트 뷰 설정
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
    }

    // 앱이 백그라운드로 전환될 때 호출되는 메서드 (홈화면 이동, 앱 강제 종료 포함)
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let navVC = window?.rootViewController as? UINavigationController else { return }

        // CoreData 서비스 준비
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let service = LastViewedScreenService(persistentContainer: container)

        // 현재 보여지는 화면에 따라 저장
        if let topVC = navVC.topViewController as? CalculatorViewController {
            service.saveLastViewedScreen(screenName: "CalculatorViewController", currencyCode: topVC.selectedCurrency)
        } else if navVC.topViewController is CurrencyViewController {
            service.saveLastViewedScreen(screenName: "CurrencyViewController", currencyCode: nil)
        }
    }
}
