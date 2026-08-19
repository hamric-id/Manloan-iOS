//
//  SearchLoansUseCase.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation

protocol SearchLoansUseCaseProtocol {
    func execute(loans: [Loan], query: String) -> [Loan]
}

final class SearchLoansUseCase: SearchLoansUseCaseProtocol {
    func execute(loans: [Loan], query: String) -> [Loan] {
        guard !query.isEmpty else { return loans }
        
        return loans.filter {
            $0.borrower.name.localizedCaseInsensitiveContains(query) ||
            $0.purpose.localizedCaseInsensitiveContains(query) ||
            $0.borrower.email.localizedCaseInsensitiveContains(query)
        }
    }
}
