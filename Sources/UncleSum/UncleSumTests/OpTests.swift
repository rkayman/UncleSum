//
//  OpTests.swift
//  UncleSumTests
//
//  Tests for Op enum
//

import Testing
@testable import UncleSum

@Suite("Op Enum Tests")
struct OpTests {
    
    @Test("Addition operation applies correctly")
    func testAdditionApply() {
        #expect(Op.add.apply(5, 3) == 8)
        #expect(Op.add.apply(0, 0) == 0)
        #expect(Op.add.apply(10, 10) == 20)
    }
    
    @Test("Subtraction operation applies correctly")
    func testSubtractionApply() {
        #expect(Op.sub.apply(5, 3) == 2)
        #expect(Op.sub.apply(10, 0) == 10)
        #expect(Op.sub.apply(20, 8) == 12)
    }
    
    @Test("Addition inverse is subtraction")
    func testAdditionInverse() {
        #expect(Op.add.inverse == .sub)
    }
    
    @Test("Subtraction inverse is addition")
    func testSubtractionInverse() {
        #expect(Op.sub.inverse == .add)
    }
    
    @Test("Raw values are correct symbols")
    func testRawValues() {
        #expect(Op.add.rawValue == "+")
        #expect(Op.sub.rawValue == "−")  // Proper minus sign
    }
    
    @Test("All cases are accounted for")
    func testAllCases() {
        #expect(Op.allCases.count == 2)
        #expect(Op.allCases.contains(.add))
        #expect(Op.allCases.contains(.sub))
    }
}
