//
//  SortLoansUseCase.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation

protocol SortLoansUseCaseProtocol {
    func execute(loans: [Loan], sort: SortOption) -> [Loan]
}

final class SortLoansUseCase: SortLoansUseCaseProtocol {
    func execute(loans: [Loan], sort: SortOption) -> [Loan] {
        var sortedLoans = loans
        
        switch sort {
        case .amount:
            sortedLoans.sort { $0.amount > $1.amount }
        case .term:
            sortedLoans.sort { $0.term > $1.term }
        case .purpose:
            sortedLoans.sort { $0.purpose < $1.purpose }
        case .risk:
            sortedLoans.sort { $0.riskRating.priority < $1.riskRating.priority }
        case .name:
            sortedLoans.sort { $0.borrower.name < $1.borrower.name }
        }
        
        return sortedLoans
    }
}
