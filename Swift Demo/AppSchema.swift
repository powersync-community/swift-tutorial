import PowerSync

/// This defines the PowerSync SQLite tables
let powerSyncSchema = Schema(
    tables: [
        Table(
            name: "counters",
            columns: [
                .integer("count"),
                .text("owner_id"),
                .text("created_at")
            ]
        )
    ]
)
