//
//  LoanListViewModel.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Combine

enum SortOption: String, CaseIterable {
    case amount = "Amount"
    case term = "Term"
    case purpose = "Purpose"
    case risk = "Risk Rating"
    case name = "Borrower"
    
    var icon: String {
        switch self {
        case .amount: return "dollarsign.circle"
        case .term: return "calendar"
        case .purpose: return "briefcase"
        case .risk: return "exclamationmark.triangle"
        case .name: return "person"
        }
    }
}

enum FilterOption: String, CaseIterable {
    case all = "All"
    case low = "Low Risk (A)"
    case medium = "Medium Risk (B)"
    case high = "High Risk (C)"
}

protocol LoanListViewModelProtocol: AnyObject {
    var loans: [Loan] { get }
    var filteredLoans: [Loan] { get }
    var isLoading: Bool { get }
    var isRefreshing: Bool { get }
    var errorMessage: String? { get }
    var searchText: String { get set }
    var selectedSort: SortOption { get set }
    var selectedFilter: FilterOption { get set }
    
    func fetchLoans()
    func refreshLoans()
    func numberOfLoans() -> Int
    func loan(at index: Int) -> Loan
}

final class LoanListViewModel: LoanListViewModelProtocol {
    @Published private(set) var loans: [Loan] = []
    @Published private(set) var filteredLoans: [Loan] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isRefreshing = false
    @Published private(set) var errorMessage: String?
    
    var searchText: String = "" {
        didSet { applyFilters() }
    }
    
    var selectedSort: SortOption = .amount {
        didSet { applyFilters() }
    }
    
    var selectedFilter: FilterOption = .all {
        didSet { applyFilters() }
    }
    
    private let fetchLoansUseCase: FetchLoansUseCaseProtocol
    private let filterLoansUseCase: FilterLoansUseCaseProtocol
    private let sortLoansUseCase: SortLoansUseCaseProtocol
    private let searchLoansUseCase: SearchLoansUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchLoansUseCase: FetchLoansUseCaseProtocol,
        filterLoansUseCase: FilterLoansUseCaseProtocol,
        sortLoansUseCase: SortLoansUseCaseProtocol,
        searchLoansUseCase: SearchLoansUseCaseProtocol
    ) {
        self.fetchLoansUseCase = fetchLoansUseCase
        self.filterLoansUseCase = filterLoansUseCase
        self.sortLoansUseCase = sortLoansUseCase
        self.searchLoansUseCase = searchLoansUseCase
    }
    
    
    func fetchLoans() {
        guard !isLoading && !isRefreshing else { return }
        
        isLoading = true
        errorMessage = nil
        
        fetchLoansUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .noInternet:
                            self?.errorMessage = "No internet connection. Please check your network."
                        case .timeout:
                            self?.errorMessage = "Request timed out. Please try again."
                        case .serverError(let code):
                            self?.errorMessage = "Server error (Code: \(code)). Please try again later."
                        case .rateLimitExceeded:
                            self?.errorMessage = "Too many requests. Please wait a moment."
                        case .decodingError:
                            self?.errorMessage = "Failed to load data. Please try again."
                        default:
                            self?.errorMessage = "Something went wrong. Please try again."
                        }
                    } else {
                        self?.errorMessage = "An unexpected error occurred. Please try again."
                    }
                }
            } receiveValue: { [weak self] loans in
                self?.loans = loans
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func refreshLoans() {
        guard !isRefreshing && !isLoading else { return }
        
        isRefreshing = true
        errorMessage = nil
        
        cancellables.removeAll()
        
        fetchLoansUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isRefreshing = false
                if case .failure(let error) = completion {
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .noInternet:
                            self?.errorMessage = "No internet connection. Please check your network."
                        case .timeout:
                            self?.errorMessage = "Request timed out. Please try again."
                        case .serverError(let code):
                            self?.errorMessage = "Server error (Code: \(code)). Please try again later."
                        default:
                            self?.errorMessage = "Failed to refresh. Please try again."
                        }
                    } else {
                        self?.errorMessage = "Refresh failed. Please try again."
                    }
                }
            } receiveValue: { [weak self] loans in
                self?.loans = loans
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func numberOfLoans() -> Int {
        return filteredLoans.count
    }
    
    func loan(at index: Int) -> Loan {
        return filteredLoans[index]
    }
    
    private func applyFilters() {
        let filtered = filterLoansUseCase.execute(loans: loans, filter: selectedFilter)
        
        let searched = searchLoansUseCase.execute(loans: filtered, query: searchText)
        
        let sorted = sortLoansUseCase.execute(loans: searched, sort: selectedSort)
        
        filteredLoans = sorted
    }
}
