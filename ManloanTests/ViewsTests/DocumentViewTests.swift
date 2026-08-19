//
//  DocumentViewTests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 20/08/26.
//


import XCTest
@testable import Manloan

final class DocumentViewTests: XCTestCase {
    
    func testDocumentCount() {

        let documents = [
            Document(type: "Income Statement", url: "/loans/doc1.pdf"),
            Document(type: "Contract", url: "/loans/doc2.pdf"),
            Document(type: "ID Card", url: "/loans/doc3.pdf")
        ]
        

        let documentView = DocumentView()
        documentView.configure(with: documents, parentViewController: nil)
        

        XCTAssertEqual(documents.count, 3)
    }
    
    func testEmptyDocumentState() {

        let emptyDocuments: [Document] = []
        

        let documentView = DocumentView()
        documentView.configure(with: emptyDocuments, parentViewController: nil)
        

        XCTAssertEqual(emptyDocuments.count, 0)
    }
    
    func testSingleDocument() {

        let documents = [
            Document(type: "Income Statement", url: "/loans/doc1.pdf")
        ]
        

        let documentView = DocumentView()
        documentView.configure(with: documents, parentViewController: nil)
        

        XCTAssertEqual(documents.count, 1)
        XCTAssertEqual(documents.first?.type, "Income Statement")
    }
}
