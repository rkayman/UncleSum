//
//  PerformanceRecord.swift
//  UncleSum
//
//  Tracks individual attempt performance for a fact
//

import Foundation
import SwiftData

/// Records a single attempt at answering a math fact
@Model
final class PerformanceRecord {
    /// The fact this record belongs to
    var fact: Fact?
    
    /// When the attempt was made
    var timestamp: Date
    
    /// Response time in seconds
    var responseTime: Double
    
    /// Whether the answer was correct
    var isCorrect: Bool
    
    /// The mode when this record was created (practice vs timed)
    var mode: String  // "practice" or "timed"
    
    init(fact: Fact, timestamp: Date = Date(), responseTime: Double, isCorrect: Bool, mode: String = "practice") {
        self.fact = fact
        self.timestamp = timestamp
        self.responseTime = responseTime
        self.isCorrect = isCorrect
        self.mode = mode
    }
}
