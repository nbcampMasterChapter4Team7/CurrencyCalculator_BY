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
        return rates.count
    }
    
    // ===== 각 행에 대한 셀을 구성하고 반환 =====
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let rate = rates[indexPath.row].value // 현재 인덱스의 환율 값을 가져옴
        let currencyCode = rates[indexPath.row].key // 현재 인덱스의 통화 코드를 가져옴
        let countryName = currencyCountryMapping[currencyCode] ?? "Unknown" // 통화 코드에 해당하는 국가 이름을 가져오고, 없으면 "Unknown" 설정
        cell.configureCell(currency: currencyCode, country: countryName, rate: String(format: "%.4f", rate)) // 셀에 통화 코드, 국가 이름, 환율 정보를 설정

        return cell
    }
    
    // ===== 각 행의 높이를 설정 =====
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
