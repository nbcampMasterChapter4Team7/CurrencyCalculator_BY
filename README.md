# CurrencyCalculator_BY

### 프로젝트 개요

CurrencyCalculator_BY는 환율 계산기 앱으로, 다양한 통화 간의 환율 계산 기능과 마지막으로 본 화면을 기억하는 기능을 제공함. MVVM 패턴을 사용하여 코드의 유지보수성을 높이고, CoreData로 데이터를 관리함.

---

### 사용한 API

- **API URL**: [https://open.er-api.com/v6/latest/USD](https://open.er-api.com/v6/latest/USD)
- **설명**: 이 API는 최신 환율 정보를 제공하며, USD를 기준으로 다른 통화의 환율 데이터를 JSON 형식으로 반환합니다. 앱 내에서 사용자가 선택한 통화 간의 환율을 계산할 때 이 데이터를 사용합니다.
- **주요 기능**:
  - 최신 환율 정보 제공
  - 다양한 통화에 대한 환율 데이터 포함

---

### 폴더 구조

```
CurrencyCalculator_BY
│
├── App
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── CoreDataCodegen
│   ├── BookmarkCurrency+CoreDataClass.swift
│   ├── BookmarkCurrency+CoreDataProperties.swift
│   ├── LastViewedScreen+CoreDataClass.swift
│   └── LastViewedScreen+CoreDataProperties.swift
│
├── DataService
│   ├── CoreDataService.swift
│   ├── CurrencyService.swift
│   └── LastViewedScreenService.swift
│
├── Extensions
│   ├── Double.Extensions.swift
│   └── UIView+Extensions.swift
│
├── Model
│   └── CurrencyCalculator_BY.xcdatamodeld
│
├── Protocols
│   └── ViewModelProtocol.swift
│
├── Resources
│   ├── Assets.xcassets
│   ├── CurrencyCountryMapping.json
│   ├── CurrencyResult.swift
│   └── Info.plist
│
├── View
│   ├── CalculatorViewController.swift
│   ├── CurrencyViewController.swift
│   ├── LaunchScreen.storyboard
│   └── TabelViewCell.swift
│
└── ViewModel
    ├── CalculatorViewModel.swift
    ├── ExchangeRateViewModel.swift
    └── RateTrendViewModel.swift

Package Dependencies
├── Alamofire 5.10.2
└── SnapKit 5.7.1
```

---

### 주요 기능 및 파일 설명

#### 환율 계산
- **파일**: `CalculatorViewController.swift`, `CalculatorViewModel.swift`
- **설명**: 
  - `CalculatorViewController.swift`: 사용자가 입력한 금액과 선택한 통화 정보를 받아 환율을 계산하고 결과를 화면에 표시함
  - `CalculatorViewModel.swift`: 환율 계산 로직을 처리하고, 계산된 결과를 ViewController에 전달함

#### 최근 본 화면 저장
- **파일**: `SceneDelegate.swift`, `LastViewedScreenService.swift`, `LastViewedScreen+CoreDataClass.swift`
- **설명**: 
  - `SceneDelegate.swift`: 앱의 씬 생명주기를 관리하며, 앱 종료 시 현재 화면 정보를 저장하고, 앱 재실행 시 복원함
  - `LastViewedScreenService.swift`: CoreData를 사용하여 마지막으로 본 화면 정보를 저장하고 불러오는 기능을 제공함
  - `LastViewedScreen+CoreDataClass.swift`: CoreData 엔티티로, 마지막 본 화면 정보를 저장하는 데 사용됨

#### 통화 정보 관리
- **파일**: `CurrencyService.swift`, `BookmarkCurrency+CoreDataClass.swift`
- **설명**:
  - `CurrencyService.swift`: 사용자가 선택한 통화 정보를 관리하고, 북마크된 통화 목록을 제공함
  - `BookmarkCurrency+CoreDataClass.swift`: CoreData 엔티티로, 사용자가 북마크한 통화 정보를 저장하고 관리함

#### 네트워크 요청
- **파일**: `CurrencyService.swift`
- **설명**:
  - `CurrencyService.swift`: Alamofire를 사용하여 API로부터 최신 환율 데이터를 가져오고, 이를 파싱하여 앱 내에서 사용할 수 있도록 제공함

#### UI 레이아웃
- **파일**: `UIView+Extensions.swift`, `SnapKit`
- **설명**:
  - `UIView+Extensions.swift`: UIView에 대한 확장 기능을 제공하여 UI 구성 요소를 쉽게 조작할 수 있도록 도와줌
  - **SnapKit**: 코드로 UI 레이아웃을 구성할 때 사용되는 라이브러리로, 제약 조건을 간편하게 설정할 수 있게 해줌

---

### 사용된 기술 및 패턴

- **MVVM 패턴**: View와 ViewModel을 분리하여 비즈니스 로직과 UI 로직을 명확히 구분했어요.
- **CoreData**: 로컬 데이터 저장 및 관리에 사용하여 앱의 데이터 일관성을 유지해요.
- **Singleton 패턴**: CoreData 서비스에서 단일 인스턴스로 데이터베이스 접근을 관리해요.

---
