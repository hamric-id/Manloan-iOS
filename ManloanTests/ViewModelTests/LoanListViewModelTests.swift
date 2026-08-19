//
//  LoanListViewModelTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import XCTest
import Combine
@testable import Manloan

final class LoanListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var mockFetchUseCase: MockFetchLoansUseCase!
    private var mockFilterUseCase: MockFilterLoansUseCase!
    private var mockSortUseCase: MockSortLoansUseCase!
    private var mockSearchUseCase: MockSearchLoansUseCase!
    private var viewModel: LoanListViewModel!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockFetchUseCase = MockFetchLoansUseCase()
        mockFilterUseCase = MockFilterLoansUseCase()
        mockSortUseCase = MockSortLoansUseCase()
        mockSearchUseCase = MockSearchLoansUseCase()
        
        viewModel = LoanListViewModel(
            fetchLoansUseCase: mockFetchUseCase,
            filterLoansUseCase: mockFilterUseCase,
            sortLoansUseCase: mockSortUseCase,
            searchLoansUseCase: mockSearchUseCase
        )
    }
    
    override func tearDown() {
        cancellables = nil
        mockFetchUseCase = nil
        mockFilterUseCase = nil
        mockSortUseCase = nil
        mockSearchUseCase = nil
        viewModel = nil
        super.tearDown()
    }
    
    
    func testFetchLoansSuccess() {

        let expectation = XCTestExpectation(description: "Fetch loans successfully")
        let mockLoan = createMockLoan(id: "1", name: "John Doe", amount: 50000)
        mockFetchUseCase.mockLoans = [mockLoan]
        

        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 1)
            XCTAssertEqual(self.viewModel.loan(at: 0).id, mockLoan.id)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchLoansError() {

        let expectation = XCTestExpectation(description: "Fetch loans with error")
        mockFetchUseCase.shouldReturnError = true
        

        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 0)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    
    func testFilterByLowRisk() {

        let loans = [
            createMockLoan(id: "1", risk: .a),
            createMockLoan(id: "2", risk: .b),
            createMockLoan(id: "3", risk: .c)
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.selectedFilter = .low
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 1)
            XCTAssertEqual(self.viewModel.loan(at: 0).riskRating, .a)
        }
    }
    
    func testFilterByMediumRisk() {

        let loans = [
            createMockLoan(id: "1", risk: .a),
            createMockLoan(id: "2", risk: .b),
            createMockLoan(id: "3", risk: .c)
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.selectedFilter = .medium
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 1)
            XCTAssertEqual(self.viewModel.loan(at: 0).riskRating, .b)
        }
    }
    
    func testFilterByHighRisk() {

        let loans = [
            createMockLoan(id: "1", risk: .a),
            createMockLoan(id: "2", risk: .b),
            createMockLoan(id: "3", risk: .c)
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.selectedFilter = .high
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 1)
            XCTAssertEqual(self.viewModel.loan(at: 0).riskRating, .c)
        }
    }
    
    
    func testSortByAmountDescending() {

        let loans = [
            createMockLoan(id: "1", amount: 1000),
            createMockLoan(id: "2", amount: 5000),
            createMockLoan(id: "3", amount: 3000)
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.selectedSort = .amount
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 3)
            XCTAssertEqual(self.viewModel.loan(at: 0).amount, 5000)
            XCTAssertEqual(self.viewModel.loan(at: 1).amount, 3000)
            XCTAssertEqual(self.viewModel.loan(at: 2).amount, 1000)
        }
    }
    
    func testSortByTermDescending() {

        let loans = [
            createMockLoan(id: "1", term: 24),
            createMockLoan(id: "2", term: 60),
            createMockLoan(id: "3", term: 36)
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.selectedSort = .term
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 3)
            XCTAssertEqual(self.viewModel.loan(at: 0).term, 60)
            XCTAssertEqual(self.viewModel.loan(at: 1).term, 36)
            XCTAssertEqual(self.viewModel.loan(at: 2).term, 24)
        }
    }
    
    
    func testSearchByBorrowerName() {

        let loans = [
            createMockLoan(id: "1", name: "Alice Smith"),
            createMockLoan(id: "2", name: "Bob Johnson"),
            createMockLoan(id: "3", name: "Carol Davis")
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.searchText = "Alice"
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 1)
            XCTAssertEqual(self.viewModel.loan(at: 0).borrower.name, "Alice Smith")
        }
    }
    
    func testSearchByPurpose() {

        let loans = [
            createMockLoan(id: "1", purpose: "Home Renovation"),
            createMockLoan(id: "2", purpose: "Car Purchase"),
            createMockLoan(id: "3", purpose: "Business Loan")
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.searchText = "Home"
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 1)
            XCTAssertEqual(self.viewModel.loan(at: 0).purpose, "Home Renovation")
        }
    }
    
    func testSearchWithEmptyQuery() {

        let loans = [
            createMockLoan(id: "1", name: "Alice Smith"),
            createMockLoan(id: "2", name: "Bob Johnson")
        ]
        mockFetchUseCase.mockLoans = loans
        viewModel.fetchLoans()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.searchText = ""
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.numberOfLoans(), 2)
        }
    }
        
    private func createMockLoan(
        id: String = "1",
        name: String = "John Doe",
        amount: Double = 50000,
        purpose: String = "Home Loan",
        risk: RiskRating = .a,
        term: Int = 36
    ) -> Loan {
        return Loan(
            id: id,
            amount: amount,
            interestRate: 0.055,
            term: term,
            purpose: purpose,
            riskRating: risk,
            borrower: Borrower(
                id: "1",
                name: name,
                email: "\(name.lowercased().replacingOccurrences(of: " ", with: "."))@example.com",
                creditScore: 720
            ),
            collateral: Collateral(type: "Real Estate", value: amount * 4),
            documents: [],
            repaymentSchedule: RepaymentSchedule(installments: [])
        )
    }
}
