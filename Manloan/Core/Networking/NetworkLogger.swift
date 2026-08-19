//
//  NetworkLogger.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        print("🚀 Request: \(urlRequest.url?.absoluteString ?? "")")
        print("📋 Method: \(urlRequest.httpMethod ?? "")")
        if let headers = urlRequest.allHTTPHeaderFields {
            print("📋 Headers: \(headers)")
        }
        if let body = urlRequest.httpBody {
            print("📦 Body: \(String(data: body, encoding: .utf8) ?? "")")
        }
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        if let statusCode = response.response?.statusCode {
            print("📥 Response Status: \(statusCode)")
        }
        if let data = response.data, let json = String(data: data, encoding: .utf8) {
            print("📦 Response Data: \(json.prefix(500))...") 
        }
        if let error = response.error {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}
