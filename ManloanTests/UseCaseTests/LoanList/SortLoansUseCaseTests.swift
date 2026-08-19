//
//  SortLoansUseCaseTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import XCTest
@testable import Manloan

final class SortLoansUseCaseTests: XCTestCase {
    private var useCase: SortLoansUseCase!
    private var sampleLoans: [Loan]!
    
    override func setUp() {
        super.setUp()
        useCase = SortLoansUseCase()
        sampleLoans = createSampleLoans()
    }
    
    override func tearDown() {
        useCase = nil
        sampleLoans = nil
        super.tearDown()
    }
    
    func testSortByAmountDescending() {

        let sort: SortOption = .amount
        

        let result = useCase.execute(loans: sampleLoans, sort: sort)
        

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].amount, 75000) 
        XCTAssertEqual(result[1].amount, 50000)
        XCTAssertEqual(result[2].amount, 25000) 
    }
    
    func testSortByTermDescending() {

        let sort: SortOption = .term
        

        let result = useCase.execute(loans: sampleLoans, sort: sort)
        

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].term, 60) 
        XCTAssertEqual(result[1].term, 36)
        XCTAssertEqual(result[2].term, 24) 
    }
    
    func testSortByPurposeAlphabetical() {

        let sort: SortOption = .purpose
        

        let result = useCase.execute(loans: sampleLoans, sort: sort)
        

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].purpose, "Business Expansion")
        XCTAssertEqual(result[1].purpose, "Education")
        XCTAssertEqual(result[2].purpose, "Home Renovation")
    }
    
    func testSortByRiskRating() {

        let sort: SortOption = .risk
        

        let result = useCase.execute(loans: sampleLoans, sort: sort)
        

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].riskRating, .a)
        XCTAssertEqual(result[1].riskRating, .b)
        XCTAssertEqual(result[2].riskRating, .c)
    }
    
    func testSortByBorrowerNameAlphabetical() {

        let sort: SortOption = .name
        

        let result = useCase.execute(loans: sampleLoans, sort: sort)
        

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].borrower.name, "Bob Johnson")
        XCTAssertEqual(result[1].borrower.name, "Jane Smith")
        XCTAssertEqual(result[2].borrower.name, "John Doe")
    }
    
    func testSortWithEmptyLoansReturnsEmpty() {

        let sort: SortOption = .amount
        let emptyLoans: [Loan] = []
        

        let result = useCase.execute(loans: emptyLoans, sort: sort)
        

        XCTAssertEqual(result.count, 0)
    }
    
    func testSortWithSingleLoanReturnsSameLoan() {

        let sort: SortOption = .amount
        let singleLoan = [sampleLoans[0]]
        

        let result = useCase.execute(loans: singleLoan, sort: sort)
        

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, sampleLoans[0].id)
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
