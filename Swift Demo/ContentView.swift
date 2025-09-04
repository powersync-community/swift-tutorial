//
//  ContentView.swift
//  Swift Demo
//
//  Created by Steven Ontong on 03-09-2025.
//

import SwiftUI

struct ContentView: View {
    @State var counters: [CounterRecord] = []
    
    let userId = UUID().uuidString

    var body: some View {
        VStack {
            List {
                ForEach(counters) { counter in
                    CounterView(
                        counter: counter,
                        onIncrement: {
                            if let idx = counters.firstIndex(
                                where: { $0.id == counter.id }
                            ) {
                                counters[idx].count += 1
                            }
                        },
                        onDelete: {
                            counters.removeAll(
                                where: {
                                    $0.id == counter.id
                                })
                        }
                    )
                }
            }
            Button {
                counters.append(
                    CounterRecord(
                        id: UUID().uuidString,
                        count: 0,
                        ownerId: userId,
                        createdAt: Date()
                    )
                )
            } label: { Text("Add Counter") }
        }
        .padding()
    }
}

#Preview {
    ContentView(
        counters: [
            CounterRecord(
                id: UUID().uuidString,
                count: 0,
                ownerId: UUID().uuidString,
                createdAt: Date()
            )
        ]
    )
}
