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
    
    private var ExchangeRateVM: ExchangeRateViewModel?
    private var currencyCode: String = ""
    
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
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupActions()
    }
    
    private func configureUI() {
        [labelStackView, rateLabel, starButton].forEach { contentView.addSubview($0) }
        [currencyLabel, countryLabel].forEach{ labelStackView.addArrangedSubview($0) }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelStackView.snp.trailing).offset(16)
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configureCell(currency: String, country: String, rate: String, viewModel: ExchangeRateViewModel) {
        currencyLabel.text = currency
        countryLabel.text = country
        rateLabel.text = rate
        currencyCode = currency
        ExchangeRateVM = viewModel
        updateBookmarksButton()
    }
    
    private func setupActions() {
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func starButtonTapped() {
        ExchangeRateVM?.toggleBookmark(currencyCode: currencyCode)
        updateBookmarksButton()
    }
    
    @objc
    private func updateBookmarksButton() {
        if ExchangeRateVM?.state.Bookmarks.contains(currencyCode) == true {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
