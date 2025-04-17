//
//  ViewController.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/16/25.
//  기본 UI 구성 및 화면 전환

import UIKit
import SnapKit

class ViewController: UIViewController {
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
    
    private func loadCurrencyCountryMapping() {
        if let path = Bundle.main.path(forResource: "CurrencyCountryMapping", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String] {
            currencyCountryMapping = json
        } else {
            print("Failed to load CurrencyCountryMapping.json")
        }
    }

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
                print("Failed to fetch rates: \(error)")
            }
        }
    }
}
