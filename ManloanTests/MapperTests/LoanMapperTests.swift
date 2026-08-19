//
//  LoanMapperTests.swift
//  Manloan
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
}
