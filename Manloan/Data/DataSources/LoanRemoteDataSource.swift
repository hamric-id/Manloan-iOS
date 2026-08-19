//
//  LoanRemoteDataSource.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Combine

protocol LoanRemoteDataSourceProtocol {
    func fetchLoans() -> AnyPublisher<[LoanDTO], NetworkError>
}

final class LoanRemoteDataSource: LoanRemoteDataSourceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchLoans() -> AnyPublisher<[LoanDTO], NetworkError> {
        return networkManager.request(LoanEndpoint.fetchLoans)
    }
}
