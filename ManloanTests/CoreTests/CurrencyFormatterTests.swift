//
//  CurrencyFormatterTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 20/08/26.
//

import XCTest
@testable import Manloan

final class CurrencyFormatterTests: XCTestCase {
    
    
    func testFormatUSDWithThousandsSeparator() {

        let amount = 100000.0
        

        let result = CurrencyFormatter.format(amount, locale: "en_US")
        

        XCTAssertEqual(result, "$100,000.00")
    }
    
    func testFormatUSDWithTwoDecimals() {

        let amount = 50000.50
        

        let result = CurrencyFormatter.format(amount, locale: "en_US")
        

        XCTAssertEqual(result, "$50,000.50")
    }
    
    func testFormatUSDWithZero() {

        let amount = 0.0
        

        let result = CurrencyFormatter.format(amount, locale: "en_US")
        

        XCTAssertEqual(result, "$0.00")
    }
    
    func testFormatUSDWithSmallAmount() {

        let amount = 9.99
        

        let result = CurrencyFormatter.format(amount, locale: "en_US")
        

        XCTAssertEqual(result, "$9.99")
    }
    

    func testFormatWithCurrencyCodeIDR() {

        let amount = 100000.0
        

        let result = CurrencyFormatter.format(amount, locale: "id_ID", minimumFractionDigits: 0)
        

        XCTAssertEqual(result, "Rp100.000")
    }
    
    func testFormatWithCustomSymbolUSD() {

        let amount = 100000.0
        

        let result = CurrencyFormatter.format(amount, locale: "en_US", currencySymbol: "US$")
        

        XCTAssertEqual(result, "US$100,000.00")
    }
    
    
    func testDoubleAsUSDcurrency() {

        let amount = 75000.0
        

        let result = amount.asUSDcurrency
        

        XCTAssertEqual(result, "US$75,000.00")
    }
    
    
    func testFormatNegativeAmount() {

        let amount = -1000.0
        

        let result = CurrencyFormatter.format(amount)
        

        XCTAssertEqual(result, "-$1,000.00")
    }
    
    func testFormatVeryLargeAmount() {

        let amount = 999999999.99
        

        let result = CurrencyFormatter.format(amount)
        

        XCTAssertEqual(result, "$999,999,999.99")
    }
}
