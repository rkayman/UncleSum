//
//  SeedFactoryTests.swift
//  UncleSumTests
//
//  Tests for SeedFactory seeding algorithm
//

import Testing
@testable import UncleSum

@Suite("SeedFactory Tests")
struct SeedFactoryTests {
    
    @Test("Generates exactly 100 facts")
    func testFactCount() {
        let facts = SeedFactory.starterFacts()
        #expect(facts.count == 100)
    }
    
    @Test("All facts are unique (Set deduplication works)")
    func testUniqueness() {
        let facts = SeedFactory.starterFacts()
        let uniqueFacts = Set(facts)
        #expect(uniqueFacts.count == facts.count)
    }
    
    @Test("Contains doubles (1..10)")
    func testDoublesPresent() {
        let facts = SeedFactory.starterFacts()
        
        let doubles = facts.filter { $0.tags.contains("doubles") }
        #expect(doubles.count >= 10)
        
        // Check specific doubles exist
        #expect(facts.contains(where: { $0.a == 5 && $0.b == 5 && $0.op == .add }))
        #expect(facts.contains(where: { $0.a == 10 && $0.b == 10 && $0.op == .add }))
    }
    
    @Test("Contains near-doubles")
    func testNearDoublesPresent() {
        let facts = SeedFactory.starterFacts()
        
        let nearDoubles = facts.filter { $0.tags.contains("nearDouble") }
        #expect(nearDoubles.count >= 9)
        
        // Check specific near-doubles
        #expect(facts.contains(where: { $0.a == 5 && $0.b == 6 && $0.op == .add }))
    }
    
    @Test("Contains make-10 pairs")
    func testMake10Present() {
        let facts = SeedFactory.starterFacts()
        
        let make10 = facts.filter { $0.tags.contains("make10") }
        #expect(make10.count >= 9)
        
        // Check specific make-10 pairs
        #expect(facts.contains(where: { $0.a == 3 && $0.b == 7 && $0.op == .add }))
        #expect(facts.contains(where: { $0.a == 9 && $0.b == 1 && $0.op == .add }))
    }
    
    @Test("Contains explicit commutativity pairs")
    func testCommutativityPairs() {
        let facts = SeedFactory.starterFacts()
        
        // Check both orders exist for key pairs
        let has6plus8 = facts.contains(where: { $0.a == 6 && $0.b == 8 && $0.op == .add })
        let has8plus6 = facts.contains(where: { $0.a == 8 && $0.b == 6 && $0.op == .add })
        
        #expect(has6plus8)
        #expect(has8plus6)
        
        let has7plus9 = facts.contains(where: { $0.a == 7 && $0.b == 9 && $0.op == .add })
        let has9plus7 = facts.contains(where: { $0.a == 9 && $0.b == 7 && $0.op == .add })
        
        #expect(has7plus9)
        #expect(has9plus7)
    }
    
    @Test("All addition facts have sums ≤ 20")
    func testAdditionBounds() {
        let facts = SeedFactory.starterFacts()
        
        let additions = facts.filter { $0.op == .add }
        for fact in additions {
            let sum = fact.answer
            #expect(sum >= 0, "Addition sum should be non-negative: \(fact.displayString)")
            #expect(sum <= 20, "Addition sum should be ≤ 20: \(fact.displayString) = \(sum)")
        }
    }
    
    @Test("All subtraction facts have non-negative results (a ≥ b)")
    func testSubtractionNonNegative() {
        let facts = SeedFactory.starterFacts()
        
        let subtractions = facts.filter { $0.op == .sub }
        for fact in subtractions {
            #expect(fact.a >= fact.b, "Subtraction must have a ≥ b: \(fact.displayString)")
            
            let result = fact.answer
            #expect(result >= 0, "Subtraction result must be non-negative: \(fact.displayString) = \(result)")
        }
    }
    
    @Test("Facts span multiple bands")
    func testBandDiversity() {
        let facts = SeedFactory.starterFacts()
        
        let hasBand1 = facts.contains(where: { $0.tags.contains("band1") })
        let hasBand2 = facts.contains(where: { $0.tags.contains("band2") })
        let hasBand3 = facts.contains(where: { $0.tags.contains("band3") })
        let hasBand4 = facts.contains(where: { $0.tags.contains("band4") })
        let hasBand5 = facts.contains(where: { $0.tags.contains("band5") })
        let hasBand6 = facts.contains(where: { $0.tags.contains("band6") })
        
        #expect(hasBand1)
        #expect(hasBand2)
        #expect(hasBand3)
        #expect(hasBand4)
        #expect(hasBand5)
        #expect(hasBand6)
    }
    
    @Test("Facts include both addition and subtraction")
    func testOperationDiversity() {
        let facts = SeedFactory.starterFacts()
        
        let additions = facts.filter { $0.op == .add }
        let subtractions = facts.filter { $0.op == .sub }
        
        #expect(additions.count > 0, "Should have addition facts")
        #expect(subtractions.count > 0, "Should have subtraction facts")
        #expect(additions.count + subtractions.count == 100)
    }
    
    @Test("All operands are in valid range [0, 20]")
    func testOperandBounds() {
        let facts = SeedFactory.starterFacts()
        
        for fact in facts {
            #expect(fact.a >= 0, "Operand a should be ≥ 0: \(fact.displayString)")
            #expect(fact.a <= 20, "Operand a should be ≤ 20: \(fact.displayString)")
            #expect(fact.b >= 0, "Operand b should be ≥ 0: \(fact.displayString)")
            #expect(fact.b <= 20, "Operand b should be ≤ 20: \(fact.displayString)")
        }
    }
    
    @Test("Each fact has at least one tag")
    func testFactTagging() {
        let facts = SeedFactory.starterFacts()
        
        for fact in facts {
            #expect(!fact.tags.isEmpty, "Fact should have at least one tag: \(fact.displayString)")
        }
    }
    
    @Test("Shuffled output varies between calls")
    func testShuffling() {
        let facts1 = SeedFactory.starterFacts()
        let facts2 = SeedFactory.starterFacts()
        
        // While sets are equal, order should differ (probabilistically)
        let set1 = Set(facts1)
        let set2 = Set(facts2)
        #expect(set1 == set2, "Same facts should be generated")
        
        // Check that order differs (very unlikely to be identical)
        let firstTenMatch = facts1.prefix(10).elementsEqual(facts2.prefix(10))
        #expect(!firstTenMatch, "Order should be shuffled (this could rarely fail)")
    }
}
