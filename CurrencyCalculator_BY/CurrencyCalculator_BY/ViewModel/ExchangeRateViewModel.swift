//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  환율 계산기 화면의 비즈니스 로직을 처리하는 뷰 모델
//  데이터 변환과 UI 업데이트를 담당

class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case updateState(State)
    }
    
    struct State {
        var rates: [(key: String, value: Double)] = []
        var filteredRates: [(key: String, value: Double)]? = nil
        var errorMessage: String? = nil
        var searchText: String = ""
    }
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    private let currencyCountryMapping: [String: String]
    
    init(currencyCountryMapping: [String: String]) {
        self.currencyCountryMapping = currencyCountryMapping
    }
    
    func fetchData() {
        CurrencyService.shared.fetchRates { [weak self] result in
            switch result {
            case .success(let rates):
                let sortedRates = rates.sorted(by: { $0.key < $1.key })
                self?.state.rates = sortedRates
                self?.state.errorMessage = nil
                self?.filterRates(searchText: self?.state.searchText ?? "")
            case .failure:
                self?.state.errorMessage = "데이터를 불러올 수 없습니다."
            }
            self?.action?(.updateState(self!.state))
        }
    }
    
    func updateSearchText(_ searchText: String) {
        state.searchText = searchText
        filterRates(searchText: searchText)
    }
    
    private func filterRates(searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            state.filteredRates = nil
        } else {
            // 통화 코드와 국가 이름으로 필터링
            let results = state.rates.filter {
                $0.key.lowercased().contains(searchText.lowercased()) ||
                (currencyCountryMapping[$0.key]?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            state.filteredRates = results
        }
        action?(.updateState(state))
    }
}

