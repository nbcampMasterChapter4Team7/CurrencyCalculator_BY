//
//  UITableView+Extensions.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // ===== 테이블 뷰의 섹션당 행 수 반환 =====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filtered = fillteredRates {
            return filtered.isEmpty ? 0 : filtered.count
        } else {
            return rates.count
        }
    }
    
    // ===== 각 행에 대한 셀을 구성하고 반환 =====
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let dataSource = fillteredRates ?? rates
        let rate = dataSource[indexPath.row].value
        let currencyCode = dataSource[indexPath.row].key
        let countryName = currencyCountryMapping[currencyCode] ?? "Unknown"
        cell.configureCell(currency: currencyCode, country: countryName, rate: String(format: "%.4f", rate))
        
        return cell
    }

    
    // ===== 각 행의 높이를 설정 =====
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
