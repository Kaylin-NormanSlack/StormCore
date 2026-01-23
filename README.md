# StormCore

**StormCore** is a personal, modular game framework built in **Godot** to support rapid prototyping, clean architecture, and player-focused design.

It is not a finished engine, product, or drop-in solution.  
It is a **living system** — the internal language I use to build and iterate on games quickly without accumulating architectural debt.

---

## Why StormCore Exists

After years of working across **software engineering, quality engineering, and game development**, I found that most templates optimize for *speed now* at the cost of *clarity later*.

StormCore exists to solve that problem.

Its goals are to:

- Enable **fast iteration** without tight coupling
- Favor **composition over inheritance**
- Decouple input, logic, UI, audio, and world state
- Make systems observable, testable, and replaceable
- Keep player experience and developer experience aligned

In short:

> Build games that are easy to change without breaking everything else.

---

## Design Philosophy

StormCore is built around a few core ideas:

### Systems, not scripts
Features are composed from small, focused components rather than monolithic behaviors.

### Signals as contracts
Communication flows through explicit signals and payloads instead of direct references.

### Adapters over globals
External tools, plugins, and engine features are wrapped so they can be swapped or removed without rewriting game logic.

### Intentional boundaries
UI doesn’t know about game rules. Input doesn’t know about movement.  
Systems listen; they don’t reach.

This architecture is heavily influenced by real-world engineering practices, not just game tutorials.

---

## High-Level Architecture

StormCore is organized around **directional flow** and **strict separation of concerns**.
Systems communicate through signals rather than direct dependencies.

![StormCore Architecture Diagram](stormcore-architecture.png)

### Architectural Notes

- Data and intent flow **downward**, not sideways
- Systems react to signals instead of pulling state
- Adapters isolate engine features and third-party tools
- Presentation layers never own game rules

This structure allows systems to be swapped, extended, or removed without cascading changes.
