//
//  Op.swift
//  UncleSum
//
//  Core operation type for math facts
//

import Foundation

/// Represents a mathematical operation (addition or subtraction)
enum Op: String, Codable, CaseIterable {
    case add = "+"
    case sub = "−"  // Using proper minus sign (U+2212), not hyphen
    
    /// Returns the result of applying this operation to two integers
    func apply(_ a: Int, _ b: Int) -> Int {
        switch self {
        case .add:
            return a + b
        case .sub:
            return a - b
        }
    }
    
    /// Returns the inverse operation
    var inverse: Op {
        switch self {
        case .add: return .sub
        case .sub: return .add
        }
    }
}
