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
    
    /// 환율 추세 ViewModel
    private var rateTrendVM: RateTrendViewModel?
    /// 환율 ViewModel
    private var ExchangeRateVM: ExchangeRateViewModel?
    /// 통화 코드
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
    func configureCell(currency: String, country: String, rate: String, viewModel: ExchangeRateViewModel) {
        currencyLabel.text = currency
        countryLabel.text = country
        rateLabel.text = rate
        currencyCode = currency
        ExchangeRateVM = viewModel
        
        // 임의 데이터 설정
        let previousRate = Double(rate)! + 0.4 // 이전 환율을 임의로 설정
           rateTrendVM = RateTrendViewModel(currency: currency, rate: Double(rate)!, previousRate: previousRate)
        
        updateBookmarksButton()
        trendIconSetup()
    }
    
    // ===== 상승하락 아이콘 설정 =====
    private func trendIconSetup() {
        guard let rateTrendVM = rateTrendVM else { return }
        let difference = abs(rateTrendVM.rate - rateTrendVM.previousRate)
        
        if difference > 0.01 {
            trendIconLabel.text = rateTrendVM.isRising ? "🔼" : "🔽"
        } else {
            trendIconLabel.text = "" // 아이콘을 표시하지 않음
        }
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
