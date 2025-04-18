//
//  ViewController.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/16/25.
//  기본 UI를 구성하고 환율 데이터를 불러와 테이블 뷰에 표시

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
    
    // ===== API, JSON, 필터링 사용을 위한 변수(튜플, 딕셔너리) 선언 =====
    /// rates: 환율 데이터를 저장하는 튜플 배열
    /// currencyCountryMapping: 통화 코드와 국가 이름 매핑을 저장하는 딕셔너리
    /// fillteredRates: 검색 결과를 저장하는 튜플 배열(필터링된 데이터)
    var rates: [(key: String, value: Double)] = []
    var currencyCountryMapping: [String: String] = [:]
    var fillteredRates: [(key: String, value: Double)]?
    
    // ===== 검색 바 생성 =====
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        return searchBar
    }()
    
    // ===== 테이블 뷰 생성 및 설정 =====
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
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
        print("화면 로드됨")
        searchBar.delegate = self
        tableView.delegate = self
        configureUI()
        loadCurrencyCountryMapping()
        fetchCurrencyRates()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "환율 정보"
    }
    
    // ===== UI 구성 요소를 설정하고 배치 =====
    private func configureUI() {
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
    
    // ===== JSON 파일에서 통화-국가 매핑 데이터를 로드 =====
    private func loadCurrencyCountryMapping() {
        /// CurrencyCountryMapping.json 파일을 읽어와 currencyCountryMapping 딕셔너리에 저장
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
        /// 초기에는 모든 데이터를 보여줌
        fillteredRates = rates
        CurrencyService.shared.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencyResult):
                /// API에서 가져온 환율 데이터를 정렬하여 저장
                self.rates = currencyResult.rates.sorted(by: { $0.key < $1.key })
                self.fillteredRates = nil
                DispatchQueue.main.async {
                    /// 테이블 뷰를 갱신
                    self.tableView.reloadData()
                }
            case .failure(let error):
                /// 오류 발생 시 경고창 표시
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

// ===== Lv.3 SearchBar 필터링 기능 =====
/// 검색 바에 입력된 텍스트를 기준으로 테이블 데이터를 필터링
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            /// 검색어가 없을 경우 모든 데이터를 표시
            fillteredRates = nil
            filterLabel.isHidden = true
        } else {
            /// 검색어를 기준으로 데이터를 필터링
            let results = rates.filter {
                $0.key.lowercased().contains(searchText.lowercased()) ||
                (currencyCountryMapping[$0.key]?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            fillteredRates = results
            /// 검색 결과가 없을 경우 라벨을 표시
            filterLabel.isHidden = !results.isEmpty
        }
        /// 테이블 뷰를 갱신
        tableView.reloadData()
    }
}
