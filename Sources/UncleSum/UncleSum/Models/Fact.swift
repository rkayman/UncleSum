//
//  Fact.swift
//  UncleSum
//
//  Core math fact model (e.g., 5 + 3 = 8)
//

import Foundation
import SwiftData

/// Represents a single math fact (e.g., 5 + 3)
@Model
final class Fact {
    /// First operand (0-20)
    var a: Int
    
    /// Second operand (0-20)
    var b: Int
    
    /// Operation type (addition or subtraction)
    var op: Op
    
    /// Strategy tags for learning scaffolding (e.g., "double", "make-10", "band-1")
    var tags: Set<String>
    
    /// Performance records for this fact
    @Relationship(deleteRule: .cascade, inverse: \PerformanceRecord.fact)
    var performanceRecords: [PerformanceRecord] = []
    
    init(a: Int, b: Int, op: Op, tags: Set<String> = []) {
        self.a = a
        self.b = b
        self.op = op
        self.tags = tags
    }
    
    /// The correct answer for this fact
    var answer: Int {
        op.apply(a, b)
    }
    
    /// Display string (e.g., "5 + 3")
    var displayString: String {
        "\(a) \(op.rawValue) \(b)"
    }
    
    /// Uniqueness key for deduplication (e.g., "5+3")
    var uniqueKey: String {
        "\(a)\(op.rawValue)\(b)"
    }
}

// MARK: - Hashable Conformance
extension Fact: Hashable {
    static func == (lhs: Fact, rhs: Fact) -> Bool {
        lhs.a == rhs.a && lhs.b == rhs.b && lhs.op == rhs.op
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(a)
        hasher.combine(b)
        hasher.combine(op)
    }
}
