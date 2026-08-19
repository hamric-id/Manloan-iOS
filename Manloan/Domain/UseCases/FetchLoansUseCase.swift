//
//  FetchLoansUseCase.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Combine

protocol FetchLoansUseCaseProtocol {
    func execute() -> AnyPublisher<[Loan], NetworkError>
}

protocol LoanMapperProtocol {
    func mapDTOToDomain(_ dto: LoanDTO) -> Loan
}

final class FetchLoansUseCase: FetchLoansUseCaseProtocol {
    private let repository: LoanRepositoryProtocol
    private let mapper: LoanMapperProtocol
    
    init(repository: LoanRepositoryProtocol, mapper: LoanMapperProtocol) {
        self.repository = repository
        self.mapper = mapper
    }
    
    func execute() -> AnyPublisher<[Loan], NetworkError> {
        return repository.fetchLoans()
            .map { dtos in
                dtos.map { self.mapper.mapDTOToDomain($0) }
            }
            .eraseToAnyPublisher()
    }
}

final class LoanMapper: LoanMapperProtocol {
    func mapDTOToDomain(_ dto: LoanDTO) -> Loan {
        let riskRating = RiskRating(rawValue: dto.riskRating) ?? .c
        
        let borrower = Borrower(
            id: dto.borrower.id,
            name: dto.borrower.name,
            email: dto.borrower.email,
            creditScore: dto.borrower.creditScore
        )
        
        let collateral: Collateral?
        if let collateralDTO = dto.collateral {
            collateral = Collateral(
                type: collateralDTO.type,
                value: collateralDTO.value
            )
        } else {
            collateral = nil
        }
        
        let documents = dto.documents?.map { docDTO in
            Document(
                type: docDTO.type,
                url: docDTO.url
            )
        } ?? []
        
        let installments = dto.repaymentSchedule.installments.map { installmentDTO in
            Installment(
                dueDate: installmentDTO.dueDate,
                amountDue: installmentDTO.amountDue
            )
        }
        
        let repaymentSchedule = RepaymentSchedule(installments: installments)
        
        return Loan(
            id: dto.id,
            amount: dto.amount,
            interestRate: dto.interestRate,
            term: dto.term,
            purpose: dto.purpose,
            riskRating: riskRating,
            borrower: borrower,
            collateral: collateral,
            documents: documents,
            repaymentSchedule: repaymentSchedule
        )
    }
}
