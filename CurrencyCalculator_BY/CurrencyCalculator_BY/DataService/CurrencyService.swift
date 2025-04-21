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
    func fetchRates(completion: @escaping (Result<[(key: String, value: Double)], Error>) -> Void) {
        // Alamofire를 사용하여 API 호출하고, 결과를 completion 핸들러로 전달
        let url = "https://open.er-api.com/v6/latest/USD"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let currencyResult = try decoder.decode(CurrencyResult.self, from: data)
                    
                    // rates를 [(key: String, value: Double)] 형식으로 변환
                    let ratesArray = currencyResult.rates.map { (key: $0.key, value: $0.value) }
                    completion(.success(ratesArray))
                    
                } catch let DecodingError.typeMismatch(type, context) {
                    print("타입 불일치 오류 발생: \(type), \(context.debugDescription)")
                    completion(.failure(DecodingError.typeMismatch(type, context)))
                } catch {
                    print("디코딩 중 알 수 없는 오류 발생: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

