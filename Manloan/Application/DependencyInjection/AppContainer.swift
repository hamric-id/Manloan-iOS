//
//  AppContainer.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Swinject
import UIKit

final class AppContainer {
    static let shared = AppContainer()
    private let container: Container
    
    private init() {
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager()
        }.inObjectScope(.container)
        
        container.register(LoanRemoteDataSourceProtocol.self) { resolver in
            let networkManager = resolver.resolve(NetworkManagerProtocol.self)!
            return LoanRemoteDataSource(networkManager: networkManager)
        }.inObjectScope(.transient)
        
        container.register(LoanRepositoryProtocol.self) { resolver in
            let dataSource = resolver.resolve(LoanRemoteDataSourceProtocol.self)!
            return LoanRepository(dataSource: dataSource)
        }.inObjectScope(.transient)
        
        container.register(LoanMapperProtocol.self) { _ in
            LoanMapper()
        }.inObjectScope(.transient)
        
        container.register(FetchLoansUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(LoanRepositoryProtocol.self)!
            let mapper = resolver.resolve(LoanMapperProtocol.self)!
            return FetchLoansUseCase(repository: repository, mapper: mapper)
        }.inObjectScope(.transient)
        
        container.register(FilterLoansUseCaseProtocol.self) { _ in
            FilterLoansUseCase()
        }.inObjectScope(.transient)
        
        container.register(SortLoansUseCaseProtocol.self) { _ in
            SortLoansUseCase()
        }.inObjectScope(.transient)
        
        container.register(SearchLoansUseCaseProtocol.self) { _ in
            SearchLoansUseCase()
        }.inObjectScope(.transient)
        
        // MARK: - Presentation
        container.register(LoanListViewModel.self) { resolver in
            let fetchUseCase = resolver.resolve(FetchLoansUseCaseProtocol.self)!
            let filterUseCase = resolver.resolve(FilterLoansUseCaseProtocol.self)!
            let sortUseCase = resolver.resolve(SortLoansUseCaseProtocol.self)!
            let searchUseCase = resolver.resolve(SearchLoansUseCaseProtocol.self)!
            
            return LoanListViewModel(
                fetchLoansUseCase: fetchUseCase,
                filterLoansUseCase: filterUseCase,
                sortLoansUseCase: sortUseCase,
                searchLoansUseCase: searchUseCase
            )
        }.inObjectScope(.transient)
        
        container.register(LoanListViewController.self) { resolver in
            let viewModel = resolver.resolve(LoanListViewModel.self)!
            return LoanListViewController(viewModel: viewModel)
        }.inObjectScope(.transient)
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    func resolveViewController<T: UIViewController>(_ type: T.Type) -> T {
        guard let viewController = resolve(type) else {
            fatalError("Failed to resolve \(String(describing: type))")
        }
        return viewController
    }
}
