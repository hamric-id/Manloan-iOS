//
//  MockFetchLoansUseCase.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Combine
@testable import Manloan

final class MockFetchLoansUseCase: FetchLoansUseCaseProtocol {
    var shouldReturnError = false
    var mockLoans: [Loan] = []
    
    func execute() -> AnyPublisher<[Loan], NetworkError> {
        if shouldReturnError {
            return Fail(error: .noInternet).eraseToAnyPublisher()
        }
        return Just(mockLoans)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
