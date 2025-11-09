//
//  FactTests.swift
//  UncleSumTests
//
//  Tests for Fact model
//

import Testing
import SwiftData
@testable import UncleSum

@Suite("Fact Model Tests")
struct FactTests {
    
    @Test("Fact initializes with correct properties")
    func testFactInitialization() {
        let fact = Fact(a: 5, b: 3, op: .add, tags: ["double"])
        
        #expect(fact.a == 5)
        #expect(fact.b == 3)
        #expect(fact.op == .add)
        #expect(fact.tags.contains("double"))
    }
    
    @Test("Fact computes correct answer for addition")
    func testAdditionAnswer() {
        let fact = Fact(a: 7, b: 8, op: .add)
        #expect(fact.answer == 15)
    }
    
    @Test("Fact computes correct answer for subtraction")
    func testSubtractionAnswer() {
        let fact = Fact(a: 12, b: 5, op: .sub)
        #expect(fact.answer == 7)
    }
    
    @Test("Display string formats correctly for addition")
    func testAdditionDisplayString() {
        let fact = Fact(a: 6, b: 4, op: .add)
        #expect(fact.displayString == "6 + 4")
    }
    
    @Test("Display string formats correctly for subtraction")
    func testSubtractionDisplayString() {
        let fact = Fact(a: 10, b: 3, op: .sub)
        #expect(fact.displayString == "10 − 3")
    }
    
    @Test("Unique key is generated correctly")
    func testUniqueKey() {
        let fact1 = Fact(a: 5, b: 3, op: .add)
        let fact2 = Fact(a: 5, b: 3, op: .sub)
        
        #expect(fact1.uniqueKey == "5+3")
        #expect(fact2.uniqueKey == "5−3")
        #expect(fact1.uniqueKey != fact2.uniqueKey)
    }
    
    @Test("Facts with same a, b, op are equal")
    func testFactEquality() {
        let fact1 = Fact(a: 5, b: 3, op: .add, tags: ["tag1"])
        let fact2 = Fact(a: 5, b: 3, op: .add, tags: ["tag2"])
        
        #expect(fact1 == fact2)  // Tags don't affect equality
    }
    
    @Test("Facts with different a, b, or op are not equal")
    func testFactInequality() {
        let fact1 = Fact(a: 5, b: 3, op: .add)
        let fact2 = Fact(a: 5, b: 4, op: .add)
        let fact3 = Fact(a: 5, b: 3, op: .sub)
        
        #expect(fact1 != fact2)
        #expect(fact1 != fact3)
    }
    
    @Test("Facts can be used in Sets (Hashable)")
    func testFactHashable() {
        let fact1 = Fact(a: 5, b: 3, op: .add)
        let fact2 = Fact(a: 5, b: 3, op: .add)
        let fact3 = Fact(a: 6, b: 3, op: .add)
        
        let factSet: Set<Fact> = [fact1, fact2, fact3]
        
        #expect(factSet.count == 2)  // fact1 and fact2 are duplicates
    }
    
    @Test("Commutativity creates distinct facts")
    func testCommutativityDistinctness() {
        let fact1 = Fact(a: 6, b: 8, op: .add)
        let fact2 = Fact(a: 8, b: 6, op: .add)
        
        #expect(fact1 != fact2)
        #expect(fact1.answer == fact2.answer)
        #expect(fact1.uniqueKey != fact2.uniqueKey)
    }
}
