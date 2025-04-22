//
//  UITableView+Extensions.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//
import UIKit

extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    // ===== Lv.4 테이블 뷰에서 선택된 셀에 따라 CalculatorViewController로 이동하고 데이터를 전달 =====
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calculatorVC = CalculatorViewController()
        
        /// LV.4 선택된 환율 정보를 가져와 calculaotrVC에 전달
        /// 수정됨: fillteredRates와 rates를 viewModel.state에서 가져오도록 변경
        let selectedCurrency = viewModel.state.filteredRates?[indexPath.row] ?? viewModel.state.rates[indexPath.row]
        calculatorVC.selectedCurrency = selectedCurrency.key
        
        /// LV.4 라벨 출력을 위해 calculatorVC에 국가 정보를 전달
        if let country = currencyCountryMapping[selectedCurrency.key] {
            calculatorVC.selectedCountry = country
        }
        
        /// LV.5 계산기 사용을 위해 calculatorVC에 환율 정보를 전달
        calculatorVC.viewModel.exchangeRate = selectedCurrency.value
        
        navigationController?.pushViewController(calculatorVC, animated: true)
    }
    
    // ===== Lv.3 테이블 뷰의 섹션당 행 수 반환 =====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// 수정됨: fillteredRates와 rates를 viewModel.state에서 가져오도록 변경
        if let filtered = viewModel.state.filteredRates {
            return filtered.isEmpty ? 0 : filtered.count
        } else {
            return viewModel.state.rates.count
        }
    }
    
    // ===== Lv.3 각 행에 대한 셀을 구성하고 반환 =====
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        /// 수정됨: fillteredRates와 rates를 viewModel.state에서 가져오도록 변경
        let dataSource = viewModel.state.filteredRates ?? viewModel.state.rates
        let rate = dataSource[indexPath.row].value
        let currencyCode = dataSource[indexPath.row].key
        let countryName = viewModel.currencyCountryMapping[currencyCode] ?? "Unknown"
        cell.configureCell(currency: currencyCode, country: countryName, rate: String(format: "%.4f", rate))
        
        return cell
    }
    
    // ===== Lv.2 각 행의 높이를 설정 =====
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
