//
//  LoanDTO.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation

typealias LoanResponse = [LoanDTO]

struct LoanDTO: Codable {
    let id: String
    let amount: Double
    let interestRate: Double
    let term: Int
    let purpose: String
    let riskRating: String
    let borrower: BorrowerDTO
    let collateral: CollateralDTO?
    let documents: [DocumentDTO]?
    let repaymentSchedule: RepaymentScheduleDTO
}

struct BorrowerDTO: Codable {
    let id: String
    let name: String
    let email: String
    let creditScore: Int
}

struct CollateralDTO: Codable {
    let type: String
    let value: Double
}

struct DocumentDTO: Codable {
    let type: String
    let url: String
}

struct RepaymentScheduleDTO: Codable {
    let installments: [InstallmentDTO]
}

struct InstallmentDTO: Codable {
    let dueDate: String
    let amountDue: Double
}
