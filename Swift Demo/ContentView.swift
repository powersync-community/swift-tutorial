//
//  ContentView.swift
//  Swift Demo
//
//  Created by Steven Ontong on 03-09-2025.
//

import PowerSync
import SwiftUI

struct ContentView: View {
    @State var counters: [CounterRecord] = []

    let userId = UUID().uuidString
    @State var statusImageName: String = "wifi.slash"

    let powerSync = PowerSyncDatabase(
        schema: powerSyncSchema,
        dbFilename: "my-demo.sqlite"
    )

    let supabase = SupabaseConnector()

    var body: some View {
        VStack {
            List {
                ForEach(counters) { counter in
                    CounterView(
                        counter: counter,
                        onIncrement: {
                            Task {
                                do {
                                    try await powerSync.execute(
                                        sql: """
                                            UPDATE counters 
                                            SET count = count + 1
                                            WHERE id = ?
                                        """,
                                        parameters: [counter.id]
                                    )
                                } catch {
                                    print("Could not increment counter: \(error)")
                                }
                            }
                        },
                        onDelete: {
                            Task {
                                do {
                                    try await powerSync.execute(
                                        sql: """
                                            DELETE FROM counters
                                            WHERE id = ?
                                        """,
                                        parameters: [counter.id]
                                    )
                                } catch {
                                    print("Could not delete counter: \(error)")
                                }
                            }
                        }
                    )
                }
            }
            HStack {
                Button {
                    Task {
                        do {
                            try await powerSync.execute(
                                sql: """
                                    INSERT INTO counters(id, count, owner_id, created_at)
                                    VALUES(uuid(), 0, ?, strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
                                """,
                                parameters: [userId]
                            )
                        } catch {
                            print("Could not add counter: \(error)")
                        }
                    }
                } label: { Text("Add Counter") }
                Spacer()
                Button {
                    Task {
                        do {
                            try await powerSync.connect(
                                connector: supabase
                            )
                        } catch {
                            print("Could not disconnect and clear")
                        }
                    }
                } label: { Text("Connect") }
                Button {
                    Task {
                        do {
                            try await powerSync.disconnectAndClear()
                        } catch {
                            print("Could not disconnect and clear")
                        }
                    }
                } label: { Text("Disconnect And Clear") }
                Image(systemName: statusImageName)
            }
        }
        .padding()
        .task {
            do {
                /// This will automatically update the counters state whenever
                /// the result has changed.
                for try await results in try powerSync.watch(
                    options: WatchOptions(
                        sql: "SELECT * FROM counters ORDER BY created_at",
                        parameters: []
                    ) { cursor in
                        try CounterRecord(
                            id: cursor.getString(name: "id"),
                            count: cursor.getInt(name: "count"),
                            ownerId: cursor.getString(name: "owner_id"),
                            createdAt: ISO8601DateFormatter().date(
                                from: cursor.getString(name: "created_at")
                            ) ?? Date()
                        )
                    })
                {
                    counters = results
                }
            } catch {
                print("Could not watch counters: \(error)")
            }
        }
        .task {
            /// This updates the status icon from the PowerSync status
            for await status in powerSync.currentStatus.asFlow() {
                if status.connected {
                    statusImageName = "wifi"
                } else if status.connecting {
                    statusImageName = "wifi.exclamationmark"
                } else {
                    statusImageName = "wifi.slash"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
