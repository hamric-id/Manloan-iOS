//
//  NetworkManagerTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import XCTest
import Combine
@testable import Manloan

final class NetworkManagerTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        networkManager = NetworkManager()
    }
    
    override func tearDown() {
        cancellables = nil
        networkManager = nil
        super.tearDown()
    }
    
    
    func testFetchLoansRealNetworkSuccess() {

        let expectation = XCTestExpectation(description: "Fetch loans from real API")
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = networkManager.request(LoanEndpoint.fetchLoans)
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Expected success but got error: \(error)")
                    }
                },
                receiveValue: { loans in
                    XCTAssertGreaterThan(loans.count, 0, "Should fetch at least one loan")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchLoansRealNetworkDecodesCorrectly() {

        let expectation = XCTestExpectation(description: "Decode loan data correctly")
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = networkManager.request(LoanEndpoint.fetchLoans)
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Expected success but got error: \(error)")
                    }
                },
                receiveValue: { loans in
                    let firstLoan = loans.first
                    XCTAssertNotNil(firstLoan)
                    XCTAssertNotNil(firstLoan?.id)
                    XCTAssertGreaterThan(firstLoan?.amount ?? 0, 0)
                    XCTAssertNotNil(firstLoan?.borrower.name)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
}

final class MockNetworkManagerTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockNetworkManager = MockNetworkManager()
    }
    
    override func tearDown() {
        cancellables = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testMockNetworkSuccess() {

        let expectation = XCTestExpectation(description: "Mock network success")
        mockNetworkManager.mockData = MockNetworkManager.mockLoanResponse
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = mockNetworkManager.request(LoanEndpoint.fetchLoans)
        

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
    
    func testMockNetworkErrorNoInternet() {

        let expectation = XCTestExpectation(description: "Mock network error - no internet")
        mockNetworkManager.mockError = .noInternet
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = mockNetworkManager.request(LoanEndpoint.fetchLoans)
        

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
    
    func testMockNetworkErrorTimeout() {

        let expectation = XCTestExpectation(description: "Mock network error - timeout")
        mockNetworkManager.mockError = .timeout
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = mockNetworkManager.request(LoanEndpoint.fetchLoans)
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error.localizedDescription, "Request timed out")
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
    
    func testMockNetworkErrorServerError() {

        let expectation = XCTestExpectation(description: "Mock network error - server error")
        mockNetworkManager.mockError = .serverError(statusCode: 500)
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = mockNetworkManager.request(LoanEndpoint.fetchLoans)
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error.localizedDescription, "Server error: 500")
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
    
    func testMockNetworkErrorDecoding() {

        let expectation = XCTestExpectation(description: "Mock network error - decoding")
        mockNetworkManager.mockError = .decodingError
        

        let publisher: AnyPublisher<[LoanDTO], NetworkError> = mockNetworkManager.request(LoanEndpoint.fetchLoans)
        

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error.localizedDescription, "Failed to parse response data")
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
