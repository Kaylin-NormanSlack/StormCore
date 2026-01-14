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

## What This Repo Is (and Is Not)

### This repo **is**:
- A reference architecture
- A foundation for my own games and prototypes
- An evolving experiment in clean game system design

### This repo **is not**:
- A polished framework
- A tutorial
- A beginner template
- A promise of long-term API stability

Expect rough edges. Expect change.

---

## Current State

StormCore is actively evolving as it is used to build small games and demos.

Some systems may be incomplete, refactored frequently, or intentionally abstract.  
Stability is secondary to **learning, clarity, and iteration**.

---

## Usage

StormCore is primarily maintained for personal use.

If you explore it:
- Feel free to read and learn
- Borrow ideas, not expectations
- Treat it as a design reference rather than a dependency

---

## License

TBD — a license will be added once the structure stabilizes.

---

## Closing Note

StormCore represents how I think about games:  
as **systems of intent**, not piles of behavior.

If you’re curious about *why* something is structured the way it is, that’s where the real value lives.