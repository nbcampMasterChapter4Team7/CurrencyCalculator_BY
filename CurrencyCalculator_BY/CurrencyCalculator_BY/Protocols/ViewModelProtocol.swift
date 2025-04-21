//
//  Protocols.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/21/25.
//

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var action: ((Action) -> Void)? { get set }
    var state: State { get }
}
