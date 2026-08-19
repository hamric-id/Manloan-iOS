//
//  Constants.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import UIKit

enum Constants {
    enum Colors {
        static let primary = UIColor.systemBlue
        static let secondary = UIColor.systemGray
        static let background = UIColor.systemGroupedBackground
        static let cardBackground = UIColor.systemBackground
        static let lowRisk = UIColor.systemGreen
        static let mediumRisk = UIColor.systemOrange
        static let highRisk = UIColor.systemRed
    }
    
    enum Fonts {
        static let headline = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 14)
        static let caption = UIFont.systemFont(ofSize: 12)
    }
    
    enum Layout {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
    }
}