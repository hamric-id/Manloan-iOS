//
//  SearchLoansUseCaseTests.swift
//  ManloanTests
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import XCTest
@testable import Manloan

final class SearchLoansUseCaseTests: XCTestCase {
    private var useCase: SearchLoansUseCase!
    private var sampleLoans: [Loan]!
    
    override func setUp() {
        super.setUp()
        useCase = SearchLoansUseCase()
        sampleLoans = createSampleLoans()
    }
    
    override func tearDown() {
        useCase = nil
        sampleLoans = nil
        super.tearDown()
    }
    
    func testSearchByBorrowerName() {

        let query = "Alice"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].borrower.name, "Alice Smith")
    }
    
    func testSearchByBorrowerNameCaseInsensitive() {

        let query = "alice"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].borrower.name, "Alice Smith")
    }
    
    func testSearchByPartialName() {

        let query = "Ali"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].borrower.name, "Alice Smith")
    }
    
    func testSearchByPurpose() {

        let query = "Education"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].purpose, "Education")
    }
    
    func testSearchByPartialPurpose() {

        let query = "Home"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].purpose, "Home Renovation")
    }
    
    func testSearchByEmail() {

        let query = "alice@example.com"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].borrower.email, "alice@example.com")
    }
    
    func testSearchByPartialEmail() {

        let query = "@example"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 3)
    }
    
    func testSearchWithEmptyQueryReturnsAllLoans() {

        let query = ""
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 3)
    }
    
    func testSearchWithNoMatchesReturnsEmpty() {

        let query = "NonExistent"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

        XCTAssertEqual(result.count, 0)
    }
    
    func testSearchWithEmptyLoansReturnsEmpty() {

        let query = "Alice"
        let emptyLoans: [Loan] = []
        

        let result = useCase.execute(loans: emptyLoans, query: query)
        

        XCTAssertEqual(result.count, 0)
    }
    
    func testSearchBySpecialCharacters() {

        let query = "!"
        

        let result = useCase.execute(loans: sampleLoans, query: query)
        

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
                    name: "Alice Smith",
                    email: "alice@example.com",
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
