//
//  CurrencyFormatter.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import Foundation

// MARK: - Currency Formatter
struct CurrencyFormatter {
    /// Format a double value to currency string with custom symbol
    /// - Parameters:
    ///   - currencyCode: e.g EUR, some currency need define, like EUR because it used in many country
    ///   - currencySymbol: The currency symbol (e.g., "$", "€", "Rp") just if need custom, dont fill if want default
    ///   - locale: The locale identifier (e.g., "en_US", "id_ID") needed for set separator format
    static func format(_ value: Double,  locale: String = "en_US", currencyCode: String? = nil, currencySymbol: String? = nil, minimumFractionDigits: Int = 2) -> String {
        let formatter = createFormatter(locale: locale, currencyCode: currencyCode, currencySymbol: currencySymbol, minimumFractionDigits: minimumFractionDigits)
        return formatter.string(from: NSNumber(value: value)) ?? "\(currencySymbol ?? "")\(value)"
    }
    
    private static func createFormatter(locale: String = Locale.current.identifier, currencyCode: String? = nil, currencySymbol: String? = nil, minimumFractionDigits: Int = 2) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let currencyCode = currencyCode {
            formatter.currencyCode = currencyCode
        }
        if let currencySymbol = currencySymbol {
            formatter.currencySymbol = currencySymbol
        }

        formatter.locale = Locale(identifier: locale)
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        return formatter
    }
}

extension Double {
    var asUSDcurrency: String {
        return CurrencyFormatter.format(self, locale: "en_US", currencySymbol: "US$")
    }
    
    /// Format a double value to currency string with custom symbol
    /// - Parameters:
    ///   - currencyCode: e.g EUR, some currency need define, like EUR because it used in many country
    ///   - currencySymbol: The currency symbol (e.g., "$", "€", "Rp") just if need custom, dont fill if want default
    ///   - locale: The locale identifier (e.g., "en_US", "id_ID") needed for set separator format
    func asCurrency(locale: String, currencyCode: String? = nil, currencySymbol: String? = nil, minimumFractionDigits: Int = 2) -> String {
        return CurrencyFormatter.format(self, locale: locale, currencyCode: currencyCode, currencySymbol: currencySymbol, minimumFractionDigits: minimumFractionDigits)
    }
}
