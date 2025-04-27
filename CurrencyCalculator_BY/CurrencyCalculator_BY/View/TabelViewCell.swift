//
//  TabelViewCell.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  환율 정보를 표시하고 즐겨찾기 기능을 제공하는 커스텀 테이블 뷰 셀 클래스

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    static let id = "TableViewCell"
    
    /// 환율 추세, 환율 계산, 환율 계산 ViewModel
    private var ExchangeRateVM: ExchangeRateViewModel?
    private var currencyCode: String = ""
    
    // ===== 레이블들을 담는 스택뷰 =====
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    // ===== 통화 레이블 =====
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // ===== 국가 레이블 =====
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // ===== 환율 레이블 =====
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // ===== 즐겨찾기 버튼 =====
    private let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()
    
    // ===== 추세 아이콘 레이블 =====
    private let trendIconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ===== 초기화 메서드 =====
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupActions()
        
    }
    
    // ===== UI 구성 설정 =====
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        [labelStackView, rateLabel, trendIconLabel, starButton].forEach { contentView.addSubview($0) }
        [currencyLabel, countryLabel].forEach{ labelStackView.addArrangedSubview($0) }
        
        /// 레이블 스택뷰 제약 설정
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        /// 환율 레이블 제약 설정
        rateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelStackView.snp.trailing).offset(16)
        }
        
        /// 추세 아이콘 레이블 제약 설정
        trendIconLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rateLabel.snp.trailing).offset(16)
        }
        
        /// 즐겨찾기 버튼 제약 설정
        starButton.snp.makeConstraints { make in
            make.leading.equalTo(trendIconLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
           
    // ===== 셀 구성 메서드 =====
    func configureCell(exchangeRate: ExchangeRate, country: String, viewModel: ExchangeRateViewModel) {
        currencyLabel.text = exchangeRate.currencyCode
        countryLabel.text = country
        rateLabel.text = String(format: "%.4f", exchangeRate.rate)
        currencyCode = exchangeRate.currencyCode
        ExchangeRateVM = viewModel
        
        trendIconLabel.text = exchangeRate.rateChangeStatus.icon

        updateBookmarksButton()
    }
    
    // ===== 버튼 액션 설정 =====
    private func setupActions() {
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }
    
    // ===== 즐겨찾기 버튼 클릭 시 동작 메서드 =====
    @objc
    private func starButtonTapped() {
        ExchangeRateVM?.toggleBookmark(currencyCode: currencyCode)
        ExchangeRateVM?.action?(.updateBookmarks)
        updateBookmarksButton()
    }
    
    // ===== 즐겨찾기 버튼 상태 업데이트 메서드 =====
    @objc
    private func updateBookmarksButton() {
        starButton.isSelected = ExchangeRateVM?.state.Bookmarks.contains(currencyCode) ?? false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
