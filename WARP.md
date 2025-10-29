# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**UncleSum** is a second-grade math fluency app for iOS, iPadOS, and macOS. The repository currently contains comprehensive design documentation and SwiftUI code stubs—**no implementation exists yet**.

### Purpose
Build a practice and timed-quiz app to help second-graders achieve fluent, automatic recall of addition/subtraction facts (0-20, no negative results).

### Target Outcomes
- **Accuracy ≥ 95%** on mixed +/− facts 0-20
- **Automaticity:** median response time ≤ 2.0s per fact
- **Goal-based timed mode:** ≥ X correct answers in 60 seconds (student-set goal)

## Tech Stack

- **Platforms:** iOS, iPadOS, macOS
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** JSON (local-first using AppStorage or file-based)
- **Audio/Haptics:** SF haptics, optional AVSpeechSynthesizer
- **Typography:** SF Pro Rounded + monospaced digits
- **Performance Targets:** render <50ms, feedback <100ms

## Core Architecture

### Two Primary Modes

1. **Practice Mode**
   - Typed input via custom NumberKeypad or hardware keyboard
   - Immediate feedback with 2-step micro-lessons on errors
   - Near-twin retry mechanism
   - Adaptive fact queuing based on performance

2. **Timed Mode**
   - 60-second quiz with 2×2 multiple-choice grid
   - Persistent goal tracking (auto-suggest PB+2)
   - 30-minute session cap per goal attempt
   - Personal and household leaderboards

### Adaptive Engine

The core intelligence layer that:
- Weights facts by current band, recent misses, spaced review schedule, and challenge level
- Enforces mastery gates: ≥95% accuracy AND median RT ≤2s
- Injects commutativity checks (~1-in-6 probability, e.g., 6+8 and 8+6)
- Uses six learning **bands** scaffolding from doubles/near-doubles to complex decompositions

### Key Data Structures

```swift
struct Fact: Hashable {
  let a: Int
  let b: Int
  let op: Op  // .add or .sub
  let tags: Set<String>  // strategy hints, bands, fact families
}

enum Op: String { case add = "+", sub = "−" }
```

### Starter Data Seeding

`SeedFactory.starterFacts()` generates **100 curated facts** at first launch, including:
- Doubles (1..10)
- Near-doubles
- Make-10 pairs
- Bridge-10 additions
- Zero/One/Two facts
- Teen sums/differences
- **Explicit commutativity pairs** (e.g., both 6+8 and 8+6)

## Key SwiftUI Views

All views are defined in the documentation as compilable stubs:

- **`NumberKeypad`**: 4×3 grid with big ✓ button and Return support
- **`PracticeView`**: Typed input with micro-lesson sheet on errors
- **`TimedQuizView`**: 60s timer, 2×2 MCQ grid, score tracking
- **`MicroLessonView`**: 2-step coaching (strategy tip → worked example → near-twin retry)
- **`GoalPickerView`**: PB+2 auto-suggestion with stepper override
- **`AnimatedTimedSessionView`**: Full animation prototype (timer ring, rolling score, progress wheel)

## Design Principles

### Learning Model
Research-backed approach using:
- Retrieval practice
- Spaced repetition
- Interleaving
- Worked examples
- Mastery learning with gates

### Accessibility
- Touch targets ≥44pt
- Dyslexia-friendly fonts (SF Pro Rounded)
- High contrast
- Minimal reading load
- Optional voice prompts

### Guardrails
- Positive tone only
- Session caps (30 minutes)
- Growth-mindset encouragement
- No stress cues

## Documentation Structure

All design documents live in `docs/`:

- **`second_grade_math_fluency_app_prd_design_v_1.md`**: Full PRD with scope, learning model, content map, modes, adaptive engine summary, UX wireframes, acceptance criteria
- **`math_fluency_app_swift_ui_stubs_seeding_v_1.md`**: Complete SwiftUI code stubs, fact seeding algorithm, app wiring for first-run
- **`math_fluency_app_animation_system_flow.md`**: Animated system flow (Mermaid sequence diagram) and full SwiftUI animation prototype

The `docs/formatted/` directory contains webarchive versions for offline viewing.

## Development Workflow

Since no code exists yet, start by:

1. Creating an Xcode project for iOS/iPadOS/macOS
2. Implementing the `Fact` and `Op` models
3. Building `SeedFactory.starterFacts()` from the documented algorithm
4. Implementing core SwiftUI views from the stubs
5. Creating the adaptive engine with mastery gates
6. Adding first-run seeding logic with `@AppStorage("didSeedFacts")`

### Performance Expectations

- View render time: <50ms
- Feedback latency: <100ms
- MCQ distractor generation: deterministic, no negative results
- Commutativity injection: ~1-in-6 probability in adaptive queues

## Important Implementation Notes

- **No negative subtraction results**: All subtraction facts enforce a ≥ b
- **Commutativity is explicit**: Both 6+8 and 8+6 appear as separate facts in seeding and practice
- **Session caps**: Enforce 30-minute maximum per goal attempt in timed mode
- **MCQ distractors**: Generate 4 options with correct answer + 3 nearby values (±3) in range [0, 20]
- **Idempotent seeding**: First-run only using `@AppStorage` flag; `AppStore.load()` should dedupe by `Fact: Hashable`
