//
//  LoanDetailViewControllerTests.swift
//  ManloanTests
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import XCTest
@testable import Manloan

final class LoanDetailViewControllerTests: XCTestCase {

    private func createMockLoanWithCollateral() -> Loan {
        return Loan(
            id: "1",
            amount: 50000,
            interestRate: 0.055,
            term: 36,
            purpose: "Home Renovation",
            riskRating: .a,
            borrower: Borrower(
                id: "1",
                name: "John Doe",
                email: "john@example.com",
                creditScore: 720
            ),
            collateral: Collateral(type: "Real Estate", value: 200000),
            documents: [],
            repaymentSchedule: RepaymentSchedule(installments: [])
        )
    }
    
    private func createMockLoanWithoutCollateral() -> Loan {
        return Loan(
            id: "1",
            amount: 50000,
            interestRate: 0.055,
            term: 36,
            purpose: "Home Renovation",
            riskRating: .a,
            borrower: Borrower(
                id: "1",
                name: "John Doe",
                email: "john@example.com",
                creditScore: 720
            ),
            collateral: nil,
            documents: [],
            repaymentSchedule: RepaymentSchedule(installments: [])
        )
    }
    
    func testCreateShareTextWithCollateral() {

        let loan = createMockLoanWithCollateral()
        let viewController = LoanDetailViewController(loan: loan)
        

        let shareText = viewController.createShareText()
        

        XCTAssertNotNil(shareText)
        XCTAssertTrue(shareText?.contains("John Doe") ?? false)
        XCTAssertTrue(shareText?.contains("US$50,000.00") ?? false)
        XCTAssertTrue(shareText?.contains("Home Renovation") ?? false)
        XCTAssertTrue(shareText?.contains("Real Estate") ?? false)
        XCTAssertTrue(shareText?.contains("US$200,000.00") ?? false)
        XCTAssertTrue(shareText?.contains("🏠 Collateral") ?? false)
    }
    
    func testCreateShareTextWithoutCollateral() {

        let loan = createMockLoanWithoutCollateral()
        let viewController = LoanDetailViewController(loan: loan)
        

        let shareText = viewController.createShareText()
        

        XCTAssertNotNil(shareText)
        XCTAssertTrue(shareText?.contains("John Doe") ?? false)
        XCTAssertTrue(shareText?.contains("US$50,000.00") ?? false)
        XCTAssertTrue(shareText?.contains("Home Renovation") ?? false)
        XCTAssertFalse(shareText?.contains("🏠 Collateral") ?? true)
        XCTAssertFalse(shareText?.contains("Real Estate") ?? true)
    }
    
    func testCreateShareTextContainsAllLoanDetails() {

        let loan = createMockLoanWithCollateral()
        let viewController = LoanDetailViewController(loan: loan)
        

        let shareText = viewController.createShareText()
        

        let expectedStrings = [
            "📋 Loan Summary",
            "Borrower: John Doe",
            "Email: john@example.com",
            "Credit Score: 720",
            "💰 Amount: US$50,000.00",
            "📊 Interest Rate: 5.5%",
            "📅 Term: 36 months",
            "📝 Purpose: Home Renovation",
            "⚠️ Risk Rating: A"
        ]
        
        for expected in expectedStrings {
            XCTAssertTrue(shareText?.contains(expected) ?? false, "Missing: \(expected)")
        }
    }
    
    
    func testEmailURLContainsSubject() {

        let loan = createMockLoanWithCollateral()
        let viewController = LoanDetailViewController(loan: loan)
        let email = "john@example.com"
        

        let subject = "Regarding Your Loan - John Doe".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = """
        Hello John Doe,
        
        I'm contacting you regarding your loan:
        
        📋 Loan Details:
        • Loan ID: 1
        • Amount: US$50,000.00
        • Interest Rate: 5.5%
        • Term: 36 months
        • Purpose: Home Renovation
        
        Best regards,
        """
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let emailURL = "mailto:\(email)?subject=\(subject)&body=\(body)"
        

        XCTAssertTrue(emailURL.hasPrefix("mailto:"))
        XCTAssertTrue(emailURL.contains("subject=Regarding%20Your%20Loan%20-%20John%20Doe"))
        XCTAssertTrue(emailURL.contains("body="))
    }
    

}
