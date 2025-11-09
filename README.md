# UncleSum

**Math Fluency App for Second Grade** — iOS, iPadOS, and macOS

A practice and timed-quiz app designed to help second-graders achieve fluent, automatic recall of addition and subtraction facts (0-20, no negative results).

## Target Outcomes

- **Accuracy ≥ 95%** on mixed +/− facts (0-20)
- **Automaticity:** median response time ≤ 2.0s per fact
- **Goal-based timed mode:** ≥ X correct answers in 60 seconds (student-set goal)

## Tech Stack

- **Platforms:** iOS 17+, iPadOS 17+, macOS 14+
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** SwiftData
- **Testing:** Swift Testing
- **Typography:** SF Pro Rounded + monospaced digits

## Project Status

### ✅ Phase 1: Foundation (Complete)

**Core Models:**
- `Op` enum (`.add`, `.sub`) with apply and inverse operations
- `Fact` model (SwiftData @Model) with a, b, op, tags, and Hashable conformance
- `PerformanceRecord` model tracking attempts with timing and accuracy
- `SeedFactory` generating 100 curated starter facts with explicit commutativity

**Infrastructure:**
- UncleSumApp with SwiftData schema registration
- First-run seeding using @AppStorage flag
- Idempotent fact insertion with Set-based deduplication
- Placeholder ContentView showing mode selection

**Testing:**
- Swift Testing framework with comprehensive test suites
- OpTests: Operation logic and inverse relationships
- FactTests: Model initialization, Hashable conformance, commutativity
- SeedFactoryTests: 100-fact generation, bounds checking, band diversity

**Files:**
```
Sources/UncleSum/UncleSum/
├── Models/
│   ├── Op.swift
│   ├── Fact.swift
│   ├── PerformanceRecord.swift
│   └── SeedFactory.swift
├── UncleSumApp.swift
└── ContentView.swift

Sources/UncleSum/UncleSumTests/
├── OpTests.swift
├── FactTests.swift
└── SeedFactoryTests.swift
```

### 🔜 Phase 2: Core Data Models (Next)

**Planned:**
1. Implement band system (6 learning bands)
2. Build fact weighting algorithm
3. Create mastery gate logic (≥95% accuracy + ≤2s median RT)
4. Add commutativity injection (~1-in-6 probability)
5. Build fact queue manager with adaptive selection

### 📋 Future Phases

- **Phase 3:** Adaptive Engine
- **Phase 4:** Practice Mode (NumberKeypad, PracticeView, MicroLessonView)
- **Phase 5:** Timed Mode (TimedQuizView, GoalPicker, Leaderboards)
- **Phase 6:** Polish & Animations
- **Phase 7:** Testing & Refinement

## Building & Running

1. Open `Sources/UncleSum/UncleSum.xcodeproj` in Xcode
2. Select target device (iOS, iPadOS, or macOS)
3. Build and run (⌘R)

On first launch, the app will seed 100 starter facts into SwiftData.

## Testing

Run tests in Xcode:
- Product → Test (⌘U)
- Or use Test Navigator (⌘6)

All tests use Swift Testing framework with `@Test` and `@Suite` annotations.

## Design Documentation

See `docs/` for comprehensive design documentation:
- `second_grade_math_fluency_app_prd_design_v_1.md` - Full PRD
- `math_fluency_app_swift_ui_stubs_seeding_v_1.md` - SwiftUI stubs & seeding
- `math_fluency_app_animation_system_flow.md` - Animation system

## Key Implementation Notes

- **No negative subtraction results:** All subtraction facts enforce a ≥ b
- **Explicit commutativity:** Both 6+8 and 8+6 appear as separate facts
- **Idempotent seeding:** First-run only using @AppStorage flag
- **SwiftData native:** All models use @Model macro for persistence

## License

Copyright © 2025 Rob Kayman. All rights reserved.
