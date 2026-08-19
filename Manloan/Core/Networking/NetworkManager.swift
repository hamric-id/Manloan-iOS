//
//  NetworkManager.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation
import Alamofire
import Combine

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var baseURL: URL { get }
}

extension Endpoint {
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com")!
    }
    
    var headers: HTTPHeaders? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}

enum LoanEndpoint: Endpoint {
    case fetchLoans
    
    var path: String {
        switch self {
        case .fetchLoans:
            return "/andreascandle/p2p_json_test/main/api/json/loans.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}

final class NetworkManager: NetworkManagerProtocol {
    private let session: Session
    private let decoder: JSONDecoder
    
    init() {
        let logger = NetworkLogger()
        self.session = Session(eventMonitors: [logger])
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown(NSError(domain: "Self deallocated", code: -1))))
                return
            }
            
            self.session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate(statusCode: 200...299)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try self.decoder.decode(T.self, from: data)
                        promise(.success(decoded))
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📦 Raw JSON: \(jsonString.prefix(500))")
                        }
                        promise(.failure(.decodingError))
                    }
                case .failure(let error):
                    promise(.failure(self.mapError(error, response: response)))
                }
            }
        }
        .retryWhenNetworkError(maxAttempts: 3)
        .eraseToAnyPublisher()
    }
    
    private func mapError(_ error: AFError, response: AFDataResponse<Data>) -> NetworkError {
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200...299:
                return .decodingError
            case 401:
                return .unauthorized
            case 429:
                return .rateLimitExceeded
            case 400...499:
                return .serverError(statusCode: statusCode)
            case 500...599:
                return .serverError(statusCode: statusCode)
            default:
                return .serverError(statusCode: statusCode)
            }
        }
        
        if let underlyingError = error.underlyingError as? URLError {
            switch underlyingError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternet
            case .timedOut:
                return .timeout
            default:
                return .unknown(underlyingError)
            }
        }
        
        if error.isResponseSerializationError {
            return .decodingError
        }
        
        return .unknown(error)
    }
}

extension Publisher {
    func retryWhenNetworkError(maxAttempts: Int) -> AnyPublisher<Output, Failure> {
        self.catch { error -> AnyPublisher<Output, Failure> in
            guard let networkError = error as? NetworkError,
                  networkError.isRetryable,
                  maxAttempts > 0 else {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return self
                .retryWhenNetworkError(maxAttempts: maxAttempts - 1)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
