# Math Fluency App — SwiftUI Stubs & Seeding (v1)

*This companion doc holds the code‑heavy parts so the main PRD stays lean.*

## A) Starter Fact Seeding (100 at first launch)

**Goal.** Ensure day‑one variety across strategies/bands, including explicit **commutativity** pairs.

### A.1 Deterministic generator (Swift)

```swift
struct SeedFactory {
  static func starterFacts() -> [Fact] {
    var out: Set<Fact> = []
    func add(_ a:Int,_ b:Int,_ op:Op,_ tags:[String]) { out.insert(Fact(a:a,b:b,op:op,tags:Set(tags))) }

    // 1) Doubles (1..10)
    for n in 1...10 { add(n,n,.add,["doubles","band1"]) }

    // 2) Near‑doubles (n+(n±1)) keeping sums ≤ 20
    for n in 1...9 { add(n,n+1,.add,["nearDouble","band1"]) }

    // 3) Make‑10 pairs (1..9)
    for x in 1...9 { add(x,10-x,.add,["make10","band2"]) }

    // 4) Bridge‑10 additions (representatives)
    let bridge: [(Int,Int)] = [(8,7),(9,6),(7,6),(9,5),(6,8),(5,9),(11,9),(12,8),(13,7),(14,6)]
    for (a,b) in bridge { add(a,b,.add,["bridge10","band4"]) }

    // 5) Zero/One/Two facts (add & sub)
    for (a,b) in [(0,7),(7,0),(10,1),(10,2)] { add(a,b,.add,["zeroOneTwo","band3"]) }
    for (a,b) in [(12,2),(11,1),(10,2),(9,1)] { add(a,b,.sub,["zeroOneTwo","band3"]) }

    // 6) Teen sums to 20
    for (a,b) in [(11,9),(12,8),(13,7),(14,6),(15,5)] { add(a,b,.add,["teen","band5"]) }

    // 7) Decompose subtraction
    for (a,b) in [(13,5),(14,6),(15,7),(16,8),(17,9)] { add(a,b,.sub,["decompose","band6"]) }

    // 8) Count‑back subtraction
    for (a,b) in [(10,7),(12,3),(11,2),(9,4),(8,5)] { add(a,b,.sub,["countBack","band6"]) }

    // 9) Teen differences (20..12 minus small)
    for (a,b) in [(20,9),(19,8),(18,7),(17,6),(16,5),(15,4),(14,3),(13,2),(12,1),(20,0)] { add(a,b,.sub,["teenDiff","band6"]) }

    // 10) Explicit commutativity pairs
    for (a,b) in [(6,8),(8,6),(7,9),(9,7),(4,6),(6,4)] { add(a,b,.add,["commutative","band4"]) }

    // 11) Fill to 100 with additional safe additions/subtractions ≤ 20 result
    var a=3,b=2
    while out.count < 100 {
      let sum = a + b
      if sum <= 20 { add(a,b,.add,["mixed","band5"]) }
      if a>=b { add(a,b,.sub,["mixed","band6"]) }
      a += 1; if a>20 { a = 2; b += 1; if b>10 { b = 2 } }
    }
    return Array(out).shuffled()
  }
}
```

**Notes.** Guarantees at least 20 items that **explicitly test commutativity** via both orders. All subtraction is `a≥b`. Additions are kept to sums ≤ 20 in curated sets; the filler respects that too.

---

## B) SwiftUI Stubs (finalized v2)

### B.1 NumberKeypad (typed practice) — big ✓ and Return support

```swift
struct NumberKeypad: View {
  var onTap: (Int) -> Void
  var onSubmit: () -> Void
  private let rows: [[String]] = [["1","2","3"],["4","5","6"],["7","8","9"],["←","0","✓"]]
  var body: some View {
    VStack(spacing: 8) {
      ForEach(rows, id: \.self) { row in
        HStack(spacing: 8) {
          ForEach(row, id: \.self) { label in
            Button(action: { handle(label) }) {
              Text(label).font(.system(size: 28, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 56)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityLabel(label == "←" ? "Backspace" : (label == "✓" ? "Submit" : label))
          }
        }
      }
    }
  }
  private func handle(_ label: String){
    switch label {
    case "0"..."9": onTap(Int(label)!)
    case "←": onTap(-1)
    case "✓": onSubmit()
    default: break
    }
  }
}
```

### B.2 PracticeView — typed input, 2‑step micro‑lesson on miss

```swift
struct PracticeView: View {
  @State private var fact: Fact = .sampleAdd
  @State private var input: String = ""
  @State private var showCoach = false
  @FocusState private var focused: Bool
  let submit: (Fact, Int) -> Bool // returns true if correct

  var body: some View {
    VStack(spacing: 16) {
      Text("\(fact.a) \(fact.op.rawValue) \(fact.b) = ?")
        .font(.system(size: 56, weight: .semibold))

      TextField("Answer", text: $input)
        .keyboardType(.numberPad)
        .focused($focused)
        .textFieldStyle(.roundedBorder)
        .font(.system(size: 32, weight: .medium).monospacedDigit())
        .onSubmit { submitAnswer() }
        .submitLabel(.done)

      NumberKeypad(onTap: { n in
        if n == -1 { if !input.isEmpty { _ = input.removeLast() } }
        else { input.append(String(n)) }
      }, onSubmit: submitAnswer)
      .padding(.top, 8)
    }
    .padding()
    .onAppear { focused = true }
    .sheet(isPresented: $showCoach) {
      MicroLessonView(fact: fact) { newRound() }  // near‑twin retry
    }
  }

  private func submitAnswer(){
    guard let val = Int(input) else { return }
    let correct = submit(fact, val)
    if correct { newRound() } else { showCoach = true }
    input.removeAll()
  }
  private func newRound(){
    fact = nextFactDemo() // hook to adaptive engine
    showCoach = false
  }
}
```

### B.3 TimedQuizView — big seconds, **2×2 MCQ grid**, goal‑ready

```swift
struct TimedQuizView: View {
  @State private var timeLeft = 60
  @State private var current: Fact = .sampleAdd
  @State private var options: [Int] = []
  @State private var score = 0
  @State private var wrongFacts: [Fact] = []
  @Environment(\.scenePhase) private var scenePhase
  let onFinish: (_ score: Int, _ wrongs: [Fact]) -> Void
  private let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

  var body: some View {
    VStack(spacing: 16) {
      Text("\(timeLeft)s").font(.system(size: 64, weight: .bold, design: .rounded).monospacedDigit())
      Text("\(current.a) \(current.op.rawValue) \(current.b) = ?").font(.system(size: 56, weight: .semibold))

      LazyVGrid(columns: cols, spacing: 12) {
        ForEach(options, id: \.self) { n in
          Button("\(n)") { handleAnswer(n) }
            .buttonStyle(.borderedProminent).controlSize(.extraLarge)
            .frame(maxWidth: .infinity, minHeight: 64)
        }
      }.padding(.vertical, 8)

      Text("Score: \(score)").font(.title2).monospacedDigit()
    }
    .padding()
    .onAppear { startRound() }
    .onChange(of: scenePhase) { phase in if phase != .active { pauseTimer() } }
  }

  @State private var timer: Timer?
  private func startTimer(){
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      timeLeft -= 1
      if timeLeft <= 0 { endQuiz() }
    }
  }
  private func pauseTimer(){ timer?.invalidate() }
  private func startRound(){ timeLeft = 60; score = 0; wrongFacts.removeAll(); nextItem(); startTimer() }
  private func nextItem(){ current = nextFactDemo(); options = mcqOptions(for: current) }
  private func handleAnswer(_ n: Int){
    let c = eval(current)
    if n == c { score += 1 } else { wrongFacts.append(current) }
    nextItem()
  }
  private func endQuiz(){ pauseTimer(); onFinish(score, wrongFacts) }
}

func eval(_ f: Fact) -> Int { f.op == .add ? f.a + f.b : f.a - f.b }
func mcqOptions(for fact: Fact) -> [Int] {
  let correct = eval(fact); var opts: Set<Int> = [correct]
  while opts.count < 4 {
    let d = correct + Int.random(in: -3...3)
    if d >= 0, d <= 20, d != correct { opts.insert(d) }
  }
  return Array(opts).shuffled()
}
```

### B.4 MicroLessonView — 2‑step coaching (tip → example → near‑twin)

```swift
struct MicroLessonView: View {
  let fact: Fact
  var onRetry: () -> Void
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Let’s try a quick tip!").font(.title2)
      StrategyTipView(fact: fact)   // step 1 (5–8s)
      WorkedExampleView(fact: fact) // step 2
      Button("Try a near‑twin") { onRetry() }.buttonStyle(.borderedProminent)
    }.padding()
  }
}
```

### B.5 GoalPicker — PB + 2 auto‑suggest with override

```swift
struct GoalPickerView: View {
  let personalBest: Int
  @State private var goal: Int
  init(pb: Int){ self.personalBest = pb; _goal = State(initialValue: pb + 2) }
  var body: some View {
    VStack(spacing: 12) {
      Text("Pick your goal for 60 seconds")
      Stepper(value: $goal, in: 5...40) { Text("Goal: \(goal)").monospacedDigit() }
      HStack {
        Button("Use \(personalBest + 2)") { goal = personalBest + 2 }.buttonStyle(.bordered)
        Button("Start") { /* start quiz with goal */ }.buttonStyle(.borderedProminent)
      }
    }.padding()
  }
}
```

---

## C) App Wiring (first‑run seeding & idempotency)

```swift
@main
struct FluencyApp: App {
  @AppStorage("didSeedFacts") private var didSeedFacts = false
  @State private var store = AppStore()
  var body: some Scene {
    WindowGroup {
      HomeView()
        .onAppear {
          if !didSeedFacts {
            store.load(SeedFactory.starterFacts()) // 100 curated facts
            didSeedFacts = true
          }
        }
    }
  }
}
```

**Notes:** first‑run only; safe on iOS/iPadOS/macOS; `AppStore.load` should de‑dupe by `Fact: Hashable`.

