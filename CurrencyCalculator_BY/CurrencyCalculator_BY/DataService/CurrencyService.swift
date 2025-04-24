//
//  CurrencyService.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  API를 호출을 처리하는 서비스 파일, 서버와의 통신을 위한 요청과 응답 관리

import UIKit
import Alamofire

final class CurrencyService: ExchangeRateProtocol {
    
    // ===== 싱글톤 패턴으로 CurrencyService 인스턴스 생성 =====
    static let shared = CurrencyService()
    
    init() {}
    
    // ===== API로부터 데이터를 가져오는 함수 =====
    func fetchExchangeRates(completion: @escaping (Result<[ExchangeRate], Error>) -> Void) {
        let url = "https://open.er-api.com/v6/latest/USD"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let currencyResult = try decoder.decode(CurrencyResult.self, from: data)
                    
                    let timeStamp = Date(timeIntervalSince1970: TimeInterval(currencyResult.timeLastUpdateUnix))
                    
                    let exchangeRates: [ExchangeRate] = currencyResult.rates.map { currencyCode, rate in
                        return ExchangeRate(currencyCode: currencyCode, rate: rate, timestamp: timeStamp)
                    }
                    
                    completion(.success(exchangeRates))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
