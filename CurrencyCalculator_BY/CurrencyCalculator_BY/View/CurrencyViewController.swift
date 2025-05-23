//
//  CurrencyViewController.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  통화 목록을 표시하고 선택할 수 있는 뷰 컨트롤러
//  사용자가 통화를 선택하고 즐겨찾기를 누르는 화면을 관리

import UIKit
import SnapKit
import Alamofire

// ===== 환율 정보를 관리하는 뷰 모델 인스턴스 생성 =====
final class CurrencyViewController: UIViewController {
    var ExchangeRateVM = ExchangeRateViewModel()
    var RateTrendVM = ExchangeRateTrendViewModel(exchangeRateManager: ExchangeRateManager())
    
    // ===== 지원되는 인터페이스 방향 설정 =====
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight, .landscapeLeft]
    }
    
    // ===== 자동 회전 허용 여부 설정 =====
    override var shouldAutorotate: Bool {
        return true
    }
    
    // ===== 검색 바 설정 =====
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        searchBar.searchTextField.textColor = .label
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    // ===== 테이블 뷰 설정 및 셀 등록 =====
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    // ===== 검색 결과가 없을 때 표시할 라벨 설정 =====
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // ===== 뷰가 로드될 때 호출되는 메서드 =====
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel() // ExchangeRateViewModel과 바인딩
        ExchangeRateVM.fetchData() // 환율 데이터 가져오기
        
        bindRateTrendViewModel()
        RateTrendVM.action?(.fetchExchangeRates)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        configureUI() // UI 구성
    }
    
    // ===== UI 구성 및 제약 조건 설정 =====
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "환율 정보"
        tableView.addSubview(filterLabel) // 필터 라벨을 테이블 뷰에 추가
        [searchBar, tableView].forEach { view.addSubview($0) } // 검색 바와 테이블 뷰를 뷰에 추가
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        filterLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // ===== 즐겨찾기 업데이트 시 테이블 뷰 다시 로드 (ExchangeRateViewModel 바인딩) =====
    private func bindViewModel() {
        ExchangeRateVM.action = { [weak self] action in
            switch action {
            case .updateState(let state):
                self?.tableView.reloadData()
                self?.filterLabel.isHidden = !(state.filteredRates != nil && state.filteredRates!.isEmpty)
                if let errorMessage = state.errorMessage {
                    self?.showAlert(message: errorMessage)
                }
            case .updateBookmarks:
                self?.tableView.reloadData() // 즐겨찾기 업데이트 시 테이블 뷰 다시 로드
            }
        }
    }
    
    // RateTrendVM의 환율 데이터를 바인딩하여 수신하는 클로저 설정
    private func bindRateTrendViewModel() {
        RateTrendVM.bindExchangeRates { exchangeRates in
            // 수신된 환율 데이터의 개수를 출력하고 각 환율 데이터를 순회하며 통화 코드, 환율, 상태를 출력
            //TODO: 테스트 코드 => print("ViewController 수신된 환율 데이터: \(exchangeRates.count)건")
            exchangeRates.forEach { rate in
                //TODO: 테스트 코드 (삭제해도 되지만 업데이트 전인데 확인을 위해 남겨둠)
                print(" \(rate.currencyCode): \(rate.rate), 상태: \(rate.rateChangeStatus)")
            }
        }
        
        // RateTrendVM의 오류를 바인딩하여 수신하는 클로저 설정
        RateTrendVM.bindError { error in
            if let error = error {
                print("오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    // ===== 오류 메시지를 표시하는 알림 생성 =====
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// ===== UISearchBarDelegate 확장 =====
extension CurrencyViewController: UISearchBarDelegate {
    // ===== 검색 바의 텍스트가 변경될 때 호출되는 메서드 =====
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /// 뷰 모델에 검색 텍스트 업데이트
        ExchangeRateVM.updateSearchText(searchText)
    }
}
