//
//  MockFilterSortSearch.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
@testable import Manloan

final class MockFilterLoansUseCase: FilterLoansUseCaseProtocol {
    func execute(loans: [Loan], filter: FilterOption) -> [Loan] {
        switch filter {
        case .all:
            return loans
        case .low:
            return loans.filter { $0.riskRating == .a }
        case .medium:
            return loans.filter { $0.riskRating == .b }
        case .high:
            return loans.filter { $0.riskRating == .c }
        }
    }
}

final class MockSortLoansUseCase: SortLoansUseCaseProtocol {
    func execute(loans: [Loan], sort: SortOption) -> [Loan] {
        var sorted = loans
        switch sort {
        case .amount:
            sorted.sort { $0.amount > $1.amount }
        case .term:
            sorted.sort { $0.term > $1.term }
        case .purpose:
            sorted.sort { $0.purpose < $1.purpose }
        case .risk:
            sorted.sort { $0.riskRating.priority < $1.riskRating.priority }
        case .name:
            sorted.sort { $0.borrower.name < $1.borrower.name }
        }
        return sorted
    }
}

final class MockSearchLoansUseCase: SearchLoansUseCaseProtocol {
    func execute(loans: [Loan], query: String) -> [Loan] {
        guard !query.isEmpty else { return loans }
        return loans.filter {
            $0.borrower.name.localizedCaseInsensitiveContains(query) ||
            $0.purpose.localizedCaseInsensitiveContains(query) ||
            $0.borrower.email.localizedCaseInsensitiveContains(query)
        }
    }
}
