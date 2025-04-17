//
//  CurrencyService.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  API를 호출을 처리하는 서비스 파일, 서버와의 통신을 위한 요청과 응답 관리

import UIKit
import Alamofire

final class CurrencyService {
    
    // ===== 싱글톤 패턴으로 CurrencyService 인스턴스 생성 =====
    static let shared = CurrencyService()
    
    private init() {}
    
    // ===== API로부터 데이터를 가져오는 함수 =====
    func fetchData(completion: @escaping(Result<CurrencyResult, AFError>) -> Void) {
        // ===== API 요청을 위한 URL 설정 =====
        let urlComponents = URLComponents(string: "https://open.er-api.com/v6/latest/USD")
        
        guard let url = urlComponents?.url else {
            print("잘못된 url")
            return
        }
        
        // ===== 성공적으로 데이터를 가져왔을 때 완료 핸들러 호출, 실패 시 오류처리 =====
        AF.request(url).responseDecodable(of: CurrencyResult.self) { response in
            switch response.result {
            case .success(let currencyResult):
                completion(.success(currencyResult))
            case .failure(let error):
                print("데이터 가져오기 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
}
