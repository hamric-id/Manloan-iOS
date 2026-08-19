//
//  FetchLoansUseCaseTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//



import XCTest
import Combine
@testable import Manloan

final class FetchLoansUseCaseTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var mockRepository: MockLoanRepository!
    private var mapper: LoanMapper!
    private var useCase: FetchLoansUseCase!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockRepository = MockLoanRepository()
        mapper = LoanMapper()
        useCase = FetchLoansUseCase(
            repository: mockRepository,
            mapper: mapper
        )
    }
    
    override func tearDown() {
        cancellables = nil
        mockRepository = nil
        mapper = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() {

        let expectation = XCTestExpectation(description: "Execute use case successfully")
        mockRepository.mockLoans = MockNetworkManager.mockLoanResponse
        

        let publisher = useCase.execute()
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { loans in
                    XCTAssertEqual(loans.count, 3)
                    XCTAssertEqual(loans.first?.borrower.name, "John Doe")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecuteError() {

        let expectation = XCTestExpectation(description: "Execute use case with error")
        mockRepository.shouldReturnError = true
        

        let publisher = useCase.execute()
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error.localizedDescription, "No internet connection available")
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected failure but got success")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
