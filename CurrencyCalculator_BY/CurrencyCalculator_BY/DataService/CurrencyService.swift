//
//  CurrencyService.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  API를 호출을 처리하는 서비스 파일, 서버와의 통신을 위한 요청과 응답 관리

import UIKit
import Alamofire

final class CurrencyService {
    static let shared = CurrencyService()
    
    private init() {}
    
    func fetchData(completion: @escaping(Result<CurrencyResult, AFError>) -> Void) {
        let urlComponents = URLComponents(string: "https://open.er-api.com/v6/latest/USD")
        
        guard let url = urlComponents?.url else {
            print("잘못된 url")
            return
        }
        
        // API 요청을 보내고, 응답을 처리하는 부분
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
