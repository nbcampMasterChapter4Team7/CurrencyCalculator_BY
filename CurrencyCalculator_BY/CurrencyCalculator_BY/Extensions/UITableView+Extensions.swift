//
//  UITableView+Extensions.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let rate = rates[indexPath.row].value
        let currencyCode = rates[indexPath.row].key
        let countryName = currencyCountryMapping[currencyCode] ?? "Unknown"

        cell.configureCell(currency: currencyCode, country: countryName, rate: String(format: "%.4f", rate))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

