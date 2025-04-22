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

class CurrencyViewController: UIViewController {
    var viewModel: ExchangeRateViewModel!
    
    // ===== 가로 방향 지원 설정 (거꾸로 세로 지원X) =====
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight, .landscapeLeft]
    }
    
    // ===== 자동 회전 허용 =====
    override var shouldAutorotate: Bool {
        return true
    }
    
    // ===== 검색 바 생성 =====
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        return searchBar
    }()
    
    // ===== 테이블 뷰 생성 및 설정 =====
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    // ===== 검색 결과가 없을 때 표시할 라벨 생성 =====
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // ===== 뷰가 로드될 때 초기 설정 수행 =====
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ExchangeRateViewModel()
        bindViewModel()
        viewModel.fetchData()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        configureUI()
    }
    
    // ===== UI 구성 요소를 설정하고 배치 =====
    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "환율 정보"
        view.backgroundColor = .white
        tableView.addSubview(filterLabel)
        [searchBar, tableView].forEach { view.addSubview($0) }
        
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
    
    // ===== API를 통해 환율 데이터를 가져오고 테이블 뷰 갱신 =====
    private func bindViewModel() {
        viewModel.action = { [weak self] action in
            switch action {
            case .updateState(let state):
                self?.tableView.reloadData()
                self?.filterLabel.isHidden = !(state.filteredRates != nil && state.filteredRates!.isEmpty)
                if let errorMessage = state.errorMessage {
                    self?.showAlert(message: errorMessage)
                }
            }
        }
    }
    
    // ===== 데이터를 불러오지 못했을 때 오류 경고창 표시 =====
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// ===== Lv.3 SearchBar 필터링 기능 =====
extension CurrencyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }
}
