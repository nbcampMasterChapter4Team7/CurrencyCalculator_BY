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
    
    // ===== 수직으로 정렬된 라벨들을 담는 스택뷰 생성 =====
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    // ===== 통화 정보를 표시하는 라벨 생성 =====
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // ===== 국가 정보를 표시하는 라벨 생성 =====
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // ===== 환율 정보를 표시하는 라벨 생성 =====
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
    
    // ===== UI 구성 요소를 설정하고 배치 =====
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
    
    // ===== 셀에 통화, 국가, 환율 정보를 설정 =====
    func configureCell(currency: String, country: String, rate: String) {
        currencyLabel.text = currency
        countryLabel.text = country
        rateLabel.text = rate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
