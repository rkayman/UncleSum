//
//  ContentView.swift
//  UncleSum
//
//  Created by Rob Kayman on 11/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var facts: [Fact]

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // App Header
                VStack(spacing: 8) {
                    Text("UncleSum")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    Text("Math Fluency for Second Grade")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Mode Selection (Placeholder)
                VStack(spacing: 16) {
                    Button(action: {}) {
                        Label("Practice Mode", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(true)
                    
                    Button(action: {}) {
                        Label("Timed Quiz", systemImage: "timer")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(true)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Debug info
                Text("\(facts.count) facts loaded")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Fact.self, inMemory: true)
}
