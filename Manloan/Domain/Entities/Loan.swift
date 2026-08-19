//
//  Loan.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation

struct Loan: Identifiable, Equatable {
    let id: String
    let amount: Double
    let interestRate: Double
    let term: Int
    let purpose: String
    let riskRating: RiskRating
    let borrower: Borrower
    let collateral: Collateral?
    let documents: [Document]
    let repaymentSchedule: RepaymentSchedule
    
    var formattedInterestRate: String {
        return String(format: "%.1f%%", interestRate * 100)
    }
}

enum RiskRating: String, CaseIterable {
    case a = "A"
    case b = "B"
    case c = "C"
    
    var displayName: String {
        switch self {
        case .a: return "Low Risk"
        case .b: return "Medium Risk"
        case .c: return "High Risk"
        }
    }
    
    var color: String {
        switch self {
        case .a: return "systemGreen"
        case .b: return "systemOrange"
        case .c: return "systemRed"
        }
    }
    
    var priority: Int {
        switch self {
        case .a: return 1
        case .b: return 2
        case .c: return 3
        }
    }
}

struct Borrower: Equatable {
    let id: String
    let name: String
    let email: String
    let creditScore: Int
}

struct Collateral: Equatable {
    let type: String
    let value: Double
}

struct Document: Identifiable, Equatable {
    let id = UUID()
    let type: String
    let url: String
}

struct RepaymentSchedule: Equatable {
    let installments: [Installment]
}

struct Installment: Identifiable, Equatable {
    let id = UUID()
    let dueDate: String
    let amountDue: Double
    
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dueDate) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return dueDate
    }
}
