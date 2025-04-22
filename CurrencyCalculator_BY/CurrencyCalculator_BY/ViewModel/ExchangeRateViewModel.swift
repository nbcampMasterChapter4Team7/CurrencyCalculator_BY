//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  환율 화면의 비즈니스 로직을 처리하는 뷰 모델
//  데이터 변환과 필터링 업데이트를 담당

import Foundation

class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case updateState(State)
    }
    
    struct State {
        // ===== 데이터 저장 변수 =====
        /// rates: 환율 데이터
        /// filteredRates: 검색된 환율 데이터
        /// errorMessage: 오류 메시지
        /// searchText: 검색어
        var rates: [(key: String, value: Double)] = []
        var filteredRates: [(key: String, value: Double)]? = nil
        var errorMessage: String? = nil
        var searchText: String = ""
    }
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    
    // ===== 통화 코드와 국가 이름 매핑 데이터 =====
    var currencyCountryMapping: [String: String]
    
    // ===== 뷰 모델 초기화 =====
    init() {
        currencyCountryMapping = [:]
        loadCurrencyCountryMapping() // 초기화 시 매핑 데이터 로드
    }
    
    // ===== 환율 데이터 가져오기 =====
    func fetchData() {
        CurrencyService.shared.fetchRates { [weak self] result in
            switch result {
            case .success(let rates):
                /// 환율 데이터를 키 기준으로 정렬
                let sortedRates = rates.sorted(by: { $0.key < $1.key })
                self?.state.rates = sortedRates
                self?.state.errorMessage = nil
                /// 검색어를 기준으로 데이터 필터링
                self?.filterRates(searchText: self?.state.searchText ?? "")
            case .failure:
                /// 오류 발생 시 메시지 설정
                self?.state.errorMessage = "데이터를 불러올 수 없습니다."
            }
            /// 상태 업데이트 액션 호출
            self?.action?(.updateState(self!.state))
        }
    }
    
    // ===== JSON 파일에서 통화-국가 매핑 데이터를 로드 =====
    private func loadCurrencyCountryMapping() {
        if let path = Bundle.main.path(forResource: "CurrencyCountryMapping", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String] {
            currencyCountryMapping = json
            print("CurrencyCountryMapping loaded: \(currencyCountryMapping)") // 로드된 데이터 출력
        } else {
            print("Failed to load CurrencyCountryMapping.json")
        }
    }

    
    // ===== 검색어 업데이트 =====
    func updateSearchText(_ searchText: String) {
        state.searchText = searchText
        /// 검색어 변경 시 데이터 필터링
        filterRates(searchText: searchText)
    }
    
    // ===== 환율 데이터 필터링 =====
    private func filterRates(searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            /// 검색어가 비어 있을 경우 필터링 해제
            state.filteredRates = nil
        } else {
            /// 검색어에 맞는 데이터 필터링
            let results = state.rates.filter {
                $0.key.lowercased().contains(searchText.lowercased()) ||
                (currencyCountryMapping[$0.key]?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            state.filteredRates = results
        }
        /// 필터링 후 상태 업데이트 액션 호출
        action?(.updateState(state))
    }
}

