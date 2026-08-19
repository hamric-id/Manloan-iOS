//
//  MockNetworkManager.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Combine
@testable import Manloan

final class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockData: Any?
    var mockError: NetworkError?
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data = mockData as? T {
            return Just(data)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown(NSError(domain: "No mock data", code: -1)))
            .eraseToAnyPublisher()
    }
}

extension MockNetworkManager {
    static var mockLoanResponse: [LoanDTO] {
        return [
            LoanDTO(
                id: "1",
                amount: 50000,
                interestRate: 0.055,
                term: 36,
                purpose: "Home Renovation",
                riskRating: "A",
                borrower: BorrowerDTO(
                    id: "1",
                    name: "John Doe",
                    email: "john@example.com",
                    creditScore: 720
                ),
                collateral: CollateralDTO(type: "Real Estate", value: 200000),
                documents: [],
                repaymentSchedule: RepaymentScheduleDTO(installments: [])
            ),
            LoanDTO(
                id: "2",
                amount: 75000,
                interestRate: 0.065,
                term: 60,
                purpose: "Business Expansion",
                riskRating: "B",
                borrower: BorrowerDTO(
                    id: "2",
                    name: "Jane Smith",
                    email: "jane@example.com",
                    creditScore: 680
                ),
                collateral: CollateralDTO(type: "Real Estate", value: 300000),
                documents: [],
                repaymentSchedule: RepaymentScheduleDTO(installments: [])
            ),
            LoanDTO(
                id: "3",
                amount: 25000,
                interestRate: 0.075,
                term: 24,
                purpose: "Education",
                riskRating: "C",
                borrower: BorrowerDTO(
                    id: "3",
                    name: "Bob Johnson",
                    email: "bob@example.com",
                    creditScore: 620
                ),
                collateral: nil,
                documents: [],
                repaymentSchedule: RepaymentScheduleDTO(installments: [])
            )
        ]
    }
}
