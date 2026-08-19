//
//  LoanRepositoryProtocol.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation
import Combine

protocol LoanRepositoryProtocol {
    func fetchLoans() -> AnyPublisher<[LoanDTO], NetworkError>
}