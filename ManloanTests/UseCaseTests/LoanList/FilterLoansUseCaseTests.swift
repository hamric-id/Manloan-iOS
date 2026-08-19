//
//  FilterLoansUseCaseTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import XCTest
@testable import Manloan

final class FilterLoansUseCaseTests: XCTestCase {
    private var useCase: FilterLoansUseCase!
    private var sampleLoans: [Loan]!
    
    override func setUp() {
        super.setUp()
        useCase = FilterLoansUseCase()
        sampleLoans = createSampleLoans()
    }
    
    override func tearDown() {
        useCase = nil
        sampleLoans = nil
        super.tearDown()
    }
    
    func testFilterAllReturnsAllLoans() {

        let filter: FilterOption = .all
        

        let result = useCase.execute(loans: sampleLoans, filter: filter)
        

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].riskRating, .a)
        XCTAssertEqual(result[1].riskRating, .b)
        XCTAssertEqual(result[2].riskRating, .c)
    }
    
    func testFilterLowRiskReturnsOnlyARatedLoans() {

        let filter: FilterOption = .low
        

        let result = useCase.execute(loans: sampleLoans, filter: filter)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].riskRating, .a)
        XCTAssertEqual(result[0].borrower.name, "John Doe")
    }
    
    func testFilterMediumRiskReturnsOnlyBRatedLoans() {

        let filter: FilterOption = .medium
        

        let result = useCase.execute(loans: sampleLoans, filter: filter)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].riskRating, .b)
        XCTAssertEqual(result[0].borrower.name, "Jane Smith")
    }
    
    func testFilterHighRiskReturnsOnlyCRatedLoans() {

        let filter: FilterOption = .high
        

        let result = useCase.execute(loans: sampleLoans, filter: filter)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].riskRating, .c)
        XCTAssertEqual(result[0].borrower.name, "Bob Johnson")
    }
    
    func testFilterWithEmptyLoansReturnsEmpty() {

        let filter: FilterOption = .low
        let emptyLoans: [Loan] = []
        

        let result = useCase.execute(loans: emptyLoans, filter: filter)
        

        XCTAssertEqual(result.count, 0)
    }
    
    private func createSampleLoans() -> [Loan] {
        return [
            Loan(
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
            ),
            Loan(
                id: "2",
                amount: 75000,
                interestRate: 0.065,
                term: 60,
                purpose: "Business Expansion",
                riskRating: .b,
                borrower: Borrower(
                    id: "2",
                    name: "Jane Smith",
                    email: "jane@example.com",
                    creditScore: 680
                ),
                collateral: Collateral(type: "Real Estate", value: 300000),
                documents: [],
                repaymentSchedule: RepaymentSchedule(installments: [])
            ),
            Loan(
                id: "3",
                amount: 25000,
                interestRate: 0.075,
                term: 24,
                purpose: "Education",
                riskRating: .c,
                borrower: Borrower(
                    id: "3",
                    name: "Bob Johnson",
                    email: "bob@example.com",
                    creditScore: 620
                ),
                collateral: nil,
                documents: [],
                repaymentSchedule: RepaymentSchedule(installments: [])
            )
        ]
    }
}
