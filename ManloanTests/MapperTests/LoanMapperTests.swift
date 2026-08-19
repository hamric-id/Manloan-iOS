//
//  LoanMapperTests.swift
//  ManloanTests
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import XCTest
@testable import Manloan

final class LoanMapperTests: XCTestCase {
    private var mapper: LoanMapper!
    
    override func setUp() {
        super.setUp()
        mapper = LoanMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func testMapDTOToDomainSuccess() {

        let dto = LoanDTO(
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
        )
        

        let loan = mapper.mapDTOToDomain(dto)
        

        XCTAssertEqual(loan.id, "1")
        XCTAssertEqual(loan.amount, 50000)
        XCTAssertEqual(loan.interestRate, 0.055)
        XCTAssertEqual(loan.term, 36)
        XCTAssertEqual(loan.purpose, "Home Renovation")
        XCTAssertEqual(loan.riskRating, .a)
        XCTAssertEqual(loan.borrower.name, "John Doe")
        XCTAssertEqual(loan.borrower.email, "john@example.com")
        XCTAssertEqual(loan.borrower.creditScore, 720)
        XCTAssertEqual(loan.collateral?.type, "Real Estate")
        XCTAssertEqual(loan.collateral?.value, 200000)
    }
    
    func testMapDTOToDomainWithNilCollateral() {

        let dto = LoanDTO(
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
            collateral: nil,
            documents: [],
            repaymentSchedule: RepaymentScheduleDTO(installments: [])
        )
        

        let loan = mapper.mapDTOToDomain(dto)
        

        XCTAssertNil(loan.collateral)
    }
    
    func testMapDTOToDomainWithDocuments() {

        let dto = LoanDTO(
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
            collateral: nil,
            documents: [
                DocumentDTO(type: "PDF", url: "https://example.com/contract.pdf"),
                DocumentDTO(type: "PDF", url: "https://example.com/income.pdf")
            ],
            repaymentSchedule: RepaymentScheduleDTO(installments: [])
        )
        

        let loan = mapper.mapDTOToDomain(dto)
        

        XCTAssertEqual(loan.documents.count, 2)
        XCTAssertEqual(loan.documents.first?.type, "PDF")
        XCTAssertEqual(loan.documents.first?.url, "https://example.com/contract.pdf")
    }
    
    func testMapDTOToDomainWithRepaymentSchedule() {

        let dto = LoanDTO(
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
            collateral: nil,
            documents: [],
            repaymentSchedule: RepaymentScheduleDTO(installments: [
                InstallmentDTO(dueDate: "2026-01-15", amountDue: 1500),
                InstallmentDTO(dueDate: "2026-02-15", amountDue: 1500)
            ])
        )
        

        let loan = mapper.mapDTOToDomain(dto)
        

        XCTAssertEqual(loan.repaymentSchedule.installments.count, 2)
        XCTAssertEqual(loan.repaymentSchedule.installments.first?.dueDate, "2026-01-15")
        XCTAssertEqual(loan.repaymentSchedule.installments.first?.amountDue, 1500)
    }
    
    func testMapDTOToDomainWithRiskRatingB() {

        let dto = LoanDTO(
            id: "1",
            amount: 50000,
            interestRate: 0.065,
            term: 36,
            purpose: "Business",
            riskRating: "B",
            borrower: BorrowerDTO(
                id: "1",
                name: "Jane Smith",
                email: "jane@example.com",
                creditScore: 680
            ),
            collateral: nil,
            documents: [],
            repaymentSchedule: RepaymentScheduleDTO(installments: [])
        )
        

        let loan = mapper.mapDTOToDomain(dto)
        

        XCTAssertEqual(loan.riskRating, .b)
    }
    
    func testMapDTOToDomainWithRiskRatingC() {

        let dto = LoanDTO(
            id: "1",
            amount: 25000,
            interestRate: 0.075,
            term: 24,
            purpose: "Education",
            riskRating: "C",
            borrower: BorrowerDTO(
                id: "1",
                name: "Bob Johnson",
                email: "bob@example.com",
                creditScore: 620
            ),
            collateral: nil,
            documents: [],
            repaymentSchedule: RepaymentScheduleDTO(installments: [])
        )
        

        let loan = mapper.mapDTOToDomain(dto)
        

        XCTAssertEqual(loan.riskRating, .c)
    }
}
