//
//  CalcuatorViewController.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/17/25.
//  환율 계산기의 로직을 괸리하는 뷰 컨트롤러
//  사용자가 환율을 입력하고 결과를 확인할 수 있음

import UIKit
import SnapKit

class CalculatorViewController: UIViewController {
    var selectedCurrency: String?
    var selectedCountry: String?
    
    // ===== 수직으로 정렬된 라벨들을 담는 스택뷰 생성 =====
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    // ===== 통화 정보를 표시하는 라벨 생성 =====
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "나는환율코드라벨!"
        return label
    }()
    
    // ===== 국가 정보를 표시하는 라벨 생성 =====
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = "나는국가라벨!!"
        
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.placeholder = "금액을 입력하세요"
        return textField
    }()
    
    private let convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("환율 계산", for: .normal)
        //button.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "계산 결과가 여기에 표시됩니다"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "환율 계산기"
        configureUI()
        updateLabelsWithSelectedCurrency()
    }
    
    private func configureUI() {
        [currencyLabel,countryLabel].forEach { labelStackView.addArrangedSubview($0) }
        [labelStackView, amountTextField, convertButton, resultLabel].forEach { view.addSubview($0) }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    // 라벨 업데이트 메소드
    private func updateLabelsWithSelectedCurrency() {
        currencyLabel.text = selectedCurrency ?? "환율 코드 없음"
        countryLabel.text = selectedCountry ?? "국가 정보 없음"
    }
}
