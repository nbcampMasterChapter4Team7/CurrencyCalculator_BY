//
//  UITableView+Extensions.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//
import UIKit

// ===== CurrencyViewController에 UITableViewDataSource와 UITableViewDelegate를 확장 =====
extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    // ===== 사용자가 테이블 뷰의 셀을 선택했을 때 호출됨 =====
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calculatorVC = CalculatorViewController()
        
        /// 선택된 셀의 환율 정보를 가져옴
        let selectedCurrency = ExchangeRateVM.state.filteredRates?[indexPath.row] ?? ExchangeRateVM.state.rates[indexPath.row]
        calculatorVC.selectedCurrency = selectedCurrency.key
        
        /// 선택된 셀의 국가 정보를 가져옴
        if let country = ExchangeRateVM.currencyCountryMapping[selectedCurrency.key] {
            calculatorVC.selectedCountry = country
        }
        
        /// 선택된 환율 정보를 CalculatorViewController에 전달
        calculatorVC.calculatorVM.exchangeRate = selectedCurrency.value
        calculatorVC.calculatorVM.currency = selectedCurrency.key
        
        /// CalculatorViewController로 화면 전환
        navigationController?.pushViewController(calculatorVC, animated: true)
    }
    
    // ===== 테이블 뷰의 섹션당 행 수를 반환 =====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// 필터링된 환율 데이터가 있는 경우 해당 데이터의 개수를 반환
        if let filtered = ExchangeRateVM.state.filteredRates {
            return filtered.isEmpty ? 0 : filtered.count
        } else {
            /// 필터링된 데이터가 없으면 전체 환율 데이터의 개수를 반환
            return ExchangeRateVM.state.rates.count
        }
    }
    
    // ===== 각 행에 대한 셀을 구성하고 반환 =====
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// TableViewCell을 재사용 큐에서 가져옴
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        /// 데이터 소스를 결정 (필터링된 데이터 또는 전체 데이터)
        let dataSource = ExchangeRateVM.state.filteredRates ?? ExchangeRateVM.state.rates
        let rate = dataSource[indexPath.row].value
        let currencyCode = dataSource[indexPath.row].key
        let countryName = ExchangeRateVM.currencyCountryMapping[currencyCode] ?? "Unknown"
        
        /// 셀에 통화 코드, 국가 이름, 환율, 그리고 뷰 모델을 설정하여 셀을 구성
        cell.configureCell(currency: currencyCode, country: countryName, rate: String(format: "%.4f", rate), viewModel: ExchangeRateVM, rateTrendVM: RateTrendVM)
        
        return cell
    }
    
    // ===== 각 행의 높이를 설정 =====
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
