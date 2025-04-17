//
//  ViewController.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/16/25.
//  기본 UI 구성 및 화면 전환

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    // ===== 가로 방향 지원 설정 (거꾸로 세로 지원X) =====
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight, .landscapeLeft]
    }
    
    // ===== 자동 회전 허용 =====
    override var shouldAutorotate: Bool {
        return true
    }
    
    // ===== API, json 사용을 위한 변수(튜플, 딕셔너리) 선언 =====
    var rates: [(key: String, value: Double)] = []
    var currencyCountryMapping: [String: String] = [:]
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("화면 로드됨")
        configureUI()
        loadCurrencyCountryMapping()
        fetchCurrencyRates()
    }
    
    // ===== UI 구성 요소를 설정하고 배치 =====
    private func configureUI() {
        view.backgroundColor = .white
        [searchBar, tableView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // ===== JSON 파일에서 통화-국가 매핑 데이터를 로드 =====
    private func loadCurrencyCountryMapping() {
        if let path = Bundle.main.path(forResource: "CurrencyCountryMapping", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String] {
            currencyCountryMapping = json
        } else {
            print("Failed to load CurrencyCountryMapping.json")
        }
    }

    // ===== API를 통해 환율 데이터를 가져오고 테이블 뷰 갱신 =====
    private func fetchCurrencyRates() {
        CurrencyService.shared.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencyResult):
                self.rates = currencyResult.rates.sorted(by: { $0.key < $1.key })
                print("데이터 가져오기 성공: \(currencyResult)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showFetchErrorAlert(error: error)
            }
        }
    }
    
    // ===== 데이터를 불러오지 못했을 때 오류 경고창 표시 =====
    private func showFetchErrorAlert(error: AFError) {
        let alert = UIAlertController(title: "오류", message: "데이터를 불러올 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
