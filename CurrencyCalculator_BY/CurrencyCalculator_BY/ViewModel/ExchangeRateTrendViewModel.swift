import Foundation

// ViewModelProtocol을 구현하는 최종 클래스
final class ExchangeRateTrendViewModel: ViewModelProtocol {
    
    // 가능한 액션을 정의하는 열거형
    enum Action {
        case fetchExchangeRates // 환율을 가져오는 액션
    }
    
    // 상태를 나타내는 구조체
    struct State {
        var exchangeRates: [ExchangeRate] = [] // 환율 목록
        var error: Error? // 에러 정보
    }
    
    var state = State() // 현재 상태
    
    // 액션을 처리하는 클로저
    var action: ((Action) -> Void)?
    
    private let exchangeRateService: ExchangeRateProtocol // 환율 서비스 프로토콜
    private let exchangeRateManager: ExchangeRateManager // 환율 관리 객체
    
    // 바인딩 클로저
    private var exchangeRatesListener: (([ExchangeRate]) -> Void)? // 환율 변경 리스너
    private var errorListener: ((Error?) -> Void)? // 에러 변경 리스너
    
    // 환율 변경 리스너를 설정하는 메서드
    func bindExchangeRates(_ listener: @escaping ([ExchangeRate]) -> Void) {
        self.exchangeRatesListener = listener
        listener(state.exchangeRates) // 초기값 전달
    }
    
    // 에러 변경 리스너를 설정하는 메서드
    func bindError(_ listener: @escaping (Error?) -> Void) {
        self.errorListener = listener
        listener(state.error) // 초기값 전달
    }
    
    // 초기화 메서드
    init(
        exchangeRateService: ExchangeRateProtocol = CurrencyService(), // 기본값으로 CurrencyService 사용
        exchangeRateManager: ExchangeRateManager
    ) {
        self.exchangeRateService = exchangeRateService
        self.exchangeRateManager = exchangeRateManager
        setupActions() // 액션 설정
    }
    
    // 액션을 설정하는 메서드
    private func setupActions() {
        action = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .fetchExchangeRates:
                self.fetchExchangeRates() // 환율 가져오기
            }
        }
    }
    
    // 환율을 가져오는 메서드
    private func fetchExchangeRates() {
        exchangeRateService.fetchExchangeRates { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let rates):
                self.handleNewExchangeRates(rates) // 성공 시 새로운 환율 처리
                print("환율 데이터 가져오기 성공: \(rates.count)건") // 성공 시 데이터 개수 로그
            case .failure(let error):
                print("환율 데이터 가져오기 실패: \(error.localizedDescription)") // 실패 시 오류 로그
                self.updateError(error) // 실패 시 에러 업데이트
            }
        }
    }
    
    // 새로운 환율을 처리하는 메서드
    private func handleNewExchangeRates(_ rates: [ExchangeRate]) {
        let updatedRates = processNewExchangeRates(rates) // 새로운 환율 처리
        updateExchangeRateState(with: updatedRates) // 상태 업데이트
    }
    
    // 환율 상태를 업데이트하는 메서드
    private func updateExchangeRateState(with rates: [ExchangeRate]) {
        state.exchangeRates = rates
        exchangeRatesListener?(rates) // 리스너 호출
    }
    
    // 에러를 업데이트하는 메서드
    private func updateError(_ error: Error) {
        state.error = error
        errorListener?(error) // 리스너 호출
    }
    
    // 새로운 환율을 처리하는 메서드
    private func processNewExchangeRates(_ rates: [ExchangeRate]) -> [ExchangeRate] {
        return rates.map { rate in
            updateCoreDataAndGetStatus(for: rate) // 각 환율에 대해 CoreData 업데이트 및 상태 조회
        }
    }
    
    // CoreData에 환율을 업데이트하는 메서드
    private func updateExchangeRateInCoreData(_ rate: ExchangeRate) {
        self.exchangeRateManager.updateExchangeRate(
            currencyCode: rate.currencyCode,
            rate: rate.rate,
            timestamp: rate.timestamp
        )
    }
    
    // CoreData 업데이트 및 상태를 가져오는 메서드
    private func updateCoreDataAndGetStatus(for rate: ExchangeRate) -> ExchangeRate {
        updateExchangeRateInCoreData(rate) // CoreData 업데이트
        
        let status = exchangeRateManager.getRateChangeStatus(for: rate.currencyCode) // 상태 조회
        //TODO: 테스트 코드 => print("상태 조회: \(rate.currencyCode) - \(status)")
        
        return ExchangeRate(
            currencyCode: rate.currencyCode,
            rate: rate.rate,
            timestamp: rate.timestamp,
            rateChangeStatus: status // 상태 포함한 환율 반환
        )
    }
}
