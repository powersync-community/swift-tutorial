# PowerSync Swift Demo

This is a simple multi platform Swift UI Application.

# Step 1: Implementing Memory Based Counter CRUD

The initial implementation allows creating and deleting `Counter` records which are stored in memory.

Diff: [Github](https://github.com/powersync-community/swift-tutorial/compare/initial...step_1)

```bash
git diff initial step_1
```

# Step 2: Adding PowerSync for State Management

This adds the PowerSync SPM package from

```
https://github.com/powersync-ja/powersync-swift
```

The `PowerSyncDynamic` Product works well with XCode previews, add this to the main target. Be sure to select `Embed & sign`.

The `Counter` records are now persisted in a local SQLite database. The latest state is automatically tracked with a PowerSync watched query. Mutations are performed with SQLite queries.

Diff:

```bash
git diff step_1 step_2
```
