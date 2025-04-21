import Alamofire

class CurrencyViewModel: ViewModelProtocol {
    enum Action {
        case updateRates([(key: String, value: Double)])
        case showError(AFError)
    }
    
    enum State {
        case loading
        case loaded
        case error
    }
    
    var action: ((Action) -> Void)?
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                print("데이터 로딩 중...")
            case .loaded:
                print("데이터 로드 완료!")
            case .error:
                print("데이터 로드 실패!")
            }
        }
    }
    
    private var rates: [(key: String, value: Double)] = []
    
    func fetchData() {
        state = .loading
        CurrencyService.shared.fetchRates { [weak self] result in
            switch result {
            case .success(let rates):
                // 정렬 추가: key를 기준으로 오름차순 정렬
                let sortedRates = rates.sorted(by: { $0.key < $1.key })
                self?.rates = sortedRates
                self?.state = .loaded
                self?.action?(.updateRates(sortedRates))
            case .failure(let error):
                self?.state = .error
                print("데이터 가져오기 실패: \(error)")
                if let afError = error.asAFError {
                    self?.action?(.showError(afError))
                }
            }
        }
    }
}
