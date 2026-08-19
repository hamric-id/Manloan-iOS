//
//  LoanRepository.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation
import Combine

final class LoanRepository: LoanRepositoryProtocol {
    private let dataSource: LoanRemoteDataSourceProtocol
    
    init(dataSource: LoanRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchLoans() -> AnyPublisher<[LoanDTO], NetworkError> {
        return dataSource.fetchLoans()
    }
}