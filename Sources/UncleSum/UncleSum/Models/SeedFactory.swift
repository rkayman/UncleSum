//
//  SeedFactory.swift
//  UncleSum
//
//  Generates 100 curated starter facts for first-run seeding
//

import Foundation

struct SeedFactory {
    /// Generates 100 curated facts covering all key strategies and bands
    /// Includes explicit commutativity pairs (e.g., both 6+8 and 8+6)
    /// All subtraction facts enforce a ≥ b (no negative results)
    static func starterFacts() -> [Fact] {
        var out: Set<Fact> = []
        
        func add(_ a: Int, _ b: Int, _ op: Op, _ tags: [String]) {
            out.insert(Fact(a: a, b: b, op: op, tags: Set(tags)))
        }
        
        // 1) Doubles (1..10) - Band 1
        for n in 1...10 {
            add(n, n, .add, ["doubles", "band1"])
        }
        
        // 2) Near-doubles (n+(n±1)) keeping sums ≤ 20 - Band 1
        for n in 1...9 {
            add(n, n + 1, .add, ["nearDouble", "band1"])
        }
        
        // 3) Make-10 pairs (1..9) - Band 2
        for x in 1...9 {
            add(x, 10 - x, .add, ["make10", "band2"])
        }
        
        // 4) Bridge-10 additions (representatives) - Band 4
        let bridge: [(Int, Int)] = [
            (8, 7), (9, 6), (7, 6), (9, 5), (6, 8),
            (5, 9), (11, 9), (12, 8), (13, 7), (14, 6)
        ]
        for (a, b) in bridge {
            add(a, b, .add, ["bridge10", "band4"])
        }
        
        // 5) Zero/One/Two facts (add & sub) - Band 3
        for (a, b) in [(0, 7), (7, 0), (10, 1), (10, 2)] {
            add(a, b, .add, ["zeroOneTwo", "band3"])
        }
        for (a, b) in [(12, 2), (11, 1), (10, 2), (9, 1)] {
            add(a, b, .sub, ["zeroOneTwo", "band3"])
        }
        
        // 6) Teen sums to 20 - Band 5
        for (a, b) in [(11, 9), (12, 8), (13, 7), (14, 6), (15, 5)] {
            add(a, b, .add, ["teen", "band5"])
        }
        
        // 7) Decompose subtraction - Band 6
        for (a, b) in [(13, 5), (14, 6), (15, 7), (16, 8), (17, 9)] {
            add(a, b, .sub, ["decompose", "band6"])
        }
        
        // 8) Count-back subtraction - Band 6
        for (a, b) in [(10, 7), (12, 3), (11, 2), (9, 4), (8, 5)] {
            add(a, b, .sub, ["countBack", "band6"])
        }
        
        // 9) Teen differences (20..12 minus small) - Band 6
        for (a, b) in [
            (20, 9), (19, 8), (18, 7), (17, 6), (16, 5),
            (15, 4), (14, 3), (13, 2), (12, 1), (20, 0)
        ] {
            add(a, b, .sub, ["teenDiff", "band6"])
        }
        
        // 10) Explicit commutativity pairs - Band 4
        for (a, b) in [(6, 8), (8, 6), (7, 9), (9, 7), (4, 6), (6, 4)] {
            add(a, b, .add, ["commutative", "band4"])
        }
        
        // 11) Fill to 100 with additional safe additions/subtractions ≤ 20 result
        var a = 3
        var b = 2
        while out.count < 100 {
            let sum = a + b
            if sum <= 20 {
                add(a, b, .add, ["mixed", "band5"])
            }
            if a >= b {
                add(a, b, .sub, ["mixed", "band6"])
            }
            a += 1
            if a > 20 {
                a = 2
                b += 1
                if b > 10 {
                    b = 2
                }
            }
        }
        
        return Array(out).shuffled()
    }
}
