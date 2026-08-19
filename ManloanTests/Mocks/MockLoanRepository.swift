//
//  MockLoanRepository.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation
import Combine
@testable import Manloan

final class MockLoanRepository: LoanRepositoryProtocol {
    var shouldReturnError = false
    var mockLoans: [LoanDTO] = []
    
    func fetchLoans() -> AnyPublisher<[LoanDTO], NetworkError> {
        if shouldReturnError {
            return Fail(error: .noInternet).eraseToAnyPublisher()
        }
        return Just(mockLoans)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
