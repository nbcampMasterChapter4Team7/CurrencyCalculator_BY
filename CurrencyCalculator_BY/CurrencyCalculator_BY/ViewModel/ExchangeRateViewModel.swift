import Foundation
import UIKit
import CoreData

// ===== ExchangeRateViewModel 클래스 정의: 뷰 모델 프로토콜 구현 =====
class ExchangeRateViewModel: ViewModelProtocol {
    // ===== 뷰 모델에서 발생할 수 있는 액션 정의 =====
    enum Action {
        case updateState(State) // 상태 업데이트 액션
        case updateBookmarks // 즐겨찾기 업데이트 액션
    }
    
    // ===== 뷰 모델의 상태를 나타내는 구조체 정의 =====
    struct State {
        var rates: [(key: String, value: Double)] = [] // 환율 데이터 저장
        var filteredRates: [(key: String, value: Double)]? = nil // 필터링된 환율 데이터 저장
        var errorMessage: String? = nil // 오류 메시지 저장
        var searchText: String = "" // 검색어 저장
        var Bookmarks: [String] = [] // 즐겨찾기된 통화 코드 저장
    }
    
    /// 액션을 처리하는 클로저
    var action: ((Action) -> Void)?
    /// 현재 상태
    private(set) var state = State()
    /// 통화와 국가 매핑
    var currencyCountryMapping: [String: String]
    
    /// Core Data 컨텍스트
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // ===== 초기화 메서드 =====
    init() {
        currencyCountryMapping = [:]
        loadCurrencyCountryMapping() // 통화-국가 매핑 로드
        fetchBookmarks() // 초기화 시 즐겨찾기 불러오기
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
                /// 검색어에 따라 환율 필터링
                self?.filterRates(searchText: self?.state.searchText ?? "")
            case .failure:
                /// 데이터 가져오기 실패 시 오류 메시지 설정
                self?.state.errorMessage = "데이터를 불러올 수 없습니다."
            }
            /// 상태 업데이트 액션 호출
            self?.action?(.updateState(self!.state))
        }
    }
    
    // ===== 통화-국가 매핑 로드 =====
    private func loadCurrencyCountryMapping() {
        if let path = Bundle.main.path(forResource: "CurrencyCountryMapping", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String] {
            currencyCountryMapping = json
        } else {
            /// 파일 로드 실패 시 콘솔에 오류 메시지 출력
            print("Failed to load CurrencyCountryMapping.json")
        }
    }
    
    // ===== 검색 텍스트 업데이트 =====
    func updateSearchText(_ searchText: String) {
        state.searchText = searchText
        filterRates(searchText: searchText) /// 검색어에 따라 필터링
    }
    
    // ===== 환율 필터링 =====
    private func filterRates(searchText: String) {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        let allRates = state.rates

        if trimmedSearchText.isEmpty {
            /// 즐겨찾기된 데이터와 일반 데이터를 분리하여 정렬
            state.filteredRates = allRates.sorted { (first, second) in
                let isFirstBookmarked = state.Bookmarks.contains(first.key)
                let isSecondBookmarked = state.Bookmarks.contains(second.key)
                
                /// 즐겨찾기된 데이터는 상단에 배치하고, 각각 알파벳 오름차순으로 정렬
                if isFirstBookmarked == isSecondBookmarked {
                    return first.key < second.key
                }
                return isFirstBookmarked && !isSecondBookmarked
            }
        } else {
            /// 검색어에 따라 필터링 및 정렬
            let results = allRates.filter {
                $0.key.lowercased().contains(trimmedSearchText.lowercased()) ||
                (currencyCountryMapping[$0.key]?.lowercased().contains(trimmedSearchText.lowercased()) ?? false)
            }
            
            /// 검색 결과에서도 즐겨찾기된 데이터는 상단에 오도록 정렬
            state.filteredRates = results.sorted { (first, second) in
                let isFirstBookmarked = state.Bookmarks.contains(first.key)
                let isSecondBookmarked = state.Bookmarks.contains(second.key)
                
                if isFirstBookmarked == isSecondBookmarked {
                    return first.key < second.key
                }
                return isFirstBookmarked && !isSecondBookmarked
            }
        }
        /// 상태 업데이트 액션 호출
        action?(.updateState(state))
    }

    
    // ===== 즐겨찾기 기능 통합 =====
    func toggleBookmark(currencyCode: String) {
        if state.Bookmarks.contains(currencyCode) {
            removeBookmarks(currencyCode: currencyCode) /// 즐겨찾기 제거
        } else {
            addBookmarks(currencyCode: currencyCode) /// 즐겨찾기 추가
        }
        fetchBookmarks() /// 즐겨찾기 목록 갱신
        sortAndFilterRates() /// 즐겨찾기 갱신 후 정렬 및 필터링
        action?(.updateBookmarks) /// 즐겨찾기 업데이트 액션 호출
    }
    
    // ===== 환율 정렬 및 필터링 =====
    private func sortAndFilterRates() {
        let allRates = state.rates
        state.filteredRates = allRates.sorted { (first, second) in
            let isFirstBookmarked = state.Bookmarks.contains(first.key)
            let isSecondBookmarked = state.Bookmarks.contains(second.key)
            
            /// 즐겨찾기된 데이터는 상단에 배치하고, 각각 알파벳 오름차순으로 정렬
            if isFirstBookmarked == isSecondBookmarked {
                return first.key < second.key
            }
            return isFirstBookmarked && !isSecondBookmarked
        }
        action?(.updateState(state)) /// 상태 업데이트 액션 호출
    }
    
    // ===== 즐겨찾기 추가 =====
    private func addBookmarks(currencyCode: String) {
        let bookmark = BookmarkCurrency(context: context)
        bookmark.currencyCode = currencyCode
        saveContext()
    }
    
    // ===== 즐겨찾기 제거 =====
    private func removeBookmarks(currencyCode: String) {
        let request: NSFetchRequest<BookmarkCurrency> = BookmarkCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            /// 해당하는 즐겨찾기 삭제
            let bookmarks = try context.fetch(request)
            for bookmark in bookmarks {
                context.delete(bookmark)
            }
            saveContext()
        } catch {
            /// 삭제 실패 시 콘솔에 오류 메시지 출력
            print("Failed to remove favorite: \(error)")
        }
    }
    
    // ===== 컨텍스트 저장 =====
    private func saveContext() {
        do {
            try context.save()
        } catch {
            /// 저장 실패 시 콘솔에 오류 메시지 출력
            print("Failed to save context: \(error)")
        }
    }
    
    // ===== 즐겨찾기 불러오기 =====
    private func fetchBookmarks() {
        let request: NSFetchRequest<BookmarkCurrency> = BookmarkCurrency.fetchRequest()
        
        do {
            /// 즐겨찾기 데이터를 상태에 업데이트
            let bookmarks = try context.fetch(request)
            state.Bookmarks = bookmarks.map { $0.currencyCode ?? "" }
        } catch {
            /// 불러오기 실패 시 콘솔에 오류 메시지 출력
            print("Failed to fetch bookmarks: \(error)")
        }
    }
}
