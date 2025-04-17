//
//  TabelViewCell.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    static let id = "TableViewCell"
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    private func configureUI() {
        [labelStackView, rateLabel].forEach { contentView.addSubview($0) }
        [currencyLabel, countryLabel].forEach{ labelStackView.addArrangedSubview($0) }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelStackView.snp.trailing).offset(16)
        }
        
    }
    
    func configureCell(currency: String, country: String, rate: String) {
        currencyLabel.text = currency
        countryLabel.text = country
        rateLabel.text = rate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
