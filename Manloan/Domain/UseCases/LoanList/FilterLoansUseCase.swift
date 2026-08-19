//
//  FilterLoansUseCase.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation

protocol FilterLoansUseCaseProtocol {
    func execute(loans: [Loan], filter: FilterOption) -> [Loan]
}

protocol FilterStrategy {
    func apply(to loans: [Loan]) -> [Loan]
}

struct AllFilterStrategy: FilterStrategy {
    func apply(to loans: [Loan]) -> [Loan] { return loans }
}

struct RiskFilterStrategy: FilterStrategy {
    let riskRating: RiskRating
    func apply(to loans: [Loan]) -> [Loan] {
        return loans.filter { $0.riskRating == riskRating }
    }
}

final class FilterLoansUseCase: FilterLoansUseCaseProtocol {
    private let strategies: [FilterOption: FilterStrategy] = [
        .all: AllFilterStrategy(),
        .low: RiskFilterStrategy(riskRating: .a),
        .medium: RiskFilterStrategy(riskRating: .b),
        .high: RiskFilterStrategy(riskRating: .c)
    ]
    
    func execute(loans: [Loan], filter: FilterOption) -> [Loan] {
        guard let strategy = strategies[filter] else { return loans }
        return strategy.apply(to: loans)
    }
}
