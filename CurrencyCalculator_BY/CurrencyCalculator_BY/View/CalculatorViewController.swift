//
//  CalcuatorViewController.swift
//  CurrencyCalculator_BY
//
// Created by iOS study on 4/17/25.
// CalculatorViewController 클래스: 환율 계산기의 로직을 관리하는 뷰 컨트롤러
// 사용자가 환율을 입력하고 결과를 확인할 수 있는 계산기 기능을 제공

import UIKit
import SnapKit

// ===== CalculatorViewController 클래스 정의 =====
class CalculatorViewController: UIViewController {
    var selectedCurrency: String?
    var selectedCountry: String?
    var viewModel = CalculatorViewModel() ///  뷰모델 인스턴스 생성
    
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
        return label
    }()
    
    // ===== 국가 정보를 표시하는 라벨 생성 =====
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    // ===== 금액 입력을 위한 텍스트 필드 생성 =====
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.placeholder = "달러(USD)를 입력하세요"
        return textField
    }()
    
    // ===== 환율 계산 버튼 생성 =====
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
    
    // ===== 계산 결과를 표시하는 라벨 생성 =====
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "계산 결과가 여기에 표시됩니다"
        return label
    }()
    
    // ===== 뷰가 로드될 때 초기 설정 수행 =====
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "환율 계산기"
        configureUI()
        updateLabelsWithSelectedCurrency()
    }
    
    // ===== UI 구성 요소를 설정하고 배치 =====
    private func configureUI() {
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
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
    
    // ===== 선택된 통화 코드와 국가 정보를 라벨에 업데이트 =====
    private func updateLabelsWithSelectedCurrency() {
        currencyLabel.text = selectedCurrency ?? "환율 코드 없음"
        countryLabel.text = selectedCountry ?? "국가 정보 없음"
    }
    
    // ===== Lv.5 버튼 동작 시 viewModel에서 계산 로직 동작, Alert으로 입력 오류 처리 =====
    @objc
    private func convertButtonTapped() {
        if let resultText = viewModel.calculateConvertedAmount(amount: amountTextField.text ?? "") {
            resultLabel.text = resultText
            
            if resultText == "금액을 입력해주세요" || resultText == "올바른 숫자를 입력해주세요" {
                let alert = UIAlertController(title: "입력 오류", message: resultText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
