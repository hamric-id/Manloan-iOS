//
//  DocumentViewerTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 20/08/26.
//

import XCTest
@testable import Manloan

final class DocumentViewerTests: XCTestCase {
    
    func testBuildFullURL() {

        let path = "/loans/documents/income_statement/slip-gaji-karyawan-pertamina.jpeg"
        let expectedURL = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/loans/documents/income_statement/slip-gaji-karyawan-pertamina.jpeg"
        

        let result = DocumentViewerViewController.buildFullURL(for: path)
        

        XCTAssertEqual(result.absoluteString, expectedURL)
    }
    
    func testBuildFullURLWithDifferentPath() {

        let path = "/loans/documents/contract.pdf"
        let expectedURL = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/loans/documents/contract.pdf"
        

        let result = DocumentViewerViewController.buildFullURL(for: path)
        

        XCTAssertEqual(result.absoluteString, expectedURL)
    }
    
    func testBuildFullURLWithSpecialCharacters() {

        let path = "/loans/documents/my%20document.pdf"
        let expectedURL = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/loans/documents/my%20document.pdf"
        

        let result = DocumentViewerViewController.buildFullURL(for: path)
        

        XCTAssertEqual(result.absoluteString, expectedURL)
    }
    
    func testDocumentInitialization() {
        let type = "Income Statement"
        let url = "/loans/documents/income_statement/slip-gaji-karyawan-pertamina.jpeg"
        

        let document = Document(type: type, url: url)
  
        XCTAssertEqual(document.type, type)
        XCTAssertEqual(document.url, url)
    }
    
    func testDocumentWithDifferentTypes() {

        let types = [
            "Income Statement",
            "Contract",
            "ID Card",
            "Bank Statement"
        ]

        for type in types {
            let document = Document(type: type, url: "/loans/documents/test.pdf")
            XCTAssertEqual(document.type, type)
        }
    }
}

final class DocumentURLValidationTests: XCTestCase {
    
    func testDocumentURLIsValid() {

        let document = Document(
            type: "Income Statement",
            url: "/loans/documents/income_statement/slip-gaji-karyawan-pertamina.jpeg"
        )
        

        let fullURL = DocumentViewerViewController.buildFullURL(for: document.url)
        

        XCTAssertNotNil(fullURL)
        XCTAssertTrue(fullURL.absoluteString.hasPrefix("https://"))
        XCTAssertTrue(fullURL.absoluteString.contains("raw.githubusercontent.com"))
        XCTAssertTrue(fullURL.absoluteString.hasSuffix(".jpeg"))
    }
    
    func testDocumentURLWithPDF() {

        let document = Document(
            type: "Contract",
            url: "/loans/documents/contract.pdf"
        )
        

        let fullURL = DocumentViewerViewController.buildFullURL(for: document.url)
        

        XCTAssertTrue(fullURL.absoluteString.hasSuffix(".pdf"))
    }
    
    func testDocumentURLWithPNG() {

        let document = Document(
            type: "ID Card",
            url: "/loans/documents/id_card.png"
        )
        

        let fullURL = DocumentViewerViewController.buildFullURL(for: document.url)
        

        XCTAssertTrue(fullURL.absoluteString.hasSuffix(".png"))
    }
}

final class DocumentCellTests: XCTestCase {
    
    func testDocumentCellIdentifier() {
        let identifier = DocumentCell.identifier
        

        XCTAssertEqual(identifier, "DocumentCell")
    }
}
