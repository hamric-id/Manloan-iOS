//
//  NetworkError.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case timeout
    case serverError(statusCode: Int)
    case decodingError
    case unknown(Error)
    case unauthorized
    case rateLimitExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL configuration"
        case .noInternet: return "No internet connection available"
        case .timeout: return "Request timed out"
        case .serverError(let code): return "Server error: \(code)"
        case .decodingError: return "Failed to parse response data"
        case .unauthorized: return "Authentication failed"
        case .rateLimitExceeded: return "Too many requests. Please try again later."
        case .unknown(let error): return error.localizedDescription
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .noInternet, .timeout, .serverError, .rateLimitExceeded:
            return true
        default:
            return false
        }
    }
}
