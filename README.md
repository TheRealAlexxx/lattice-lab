# lattice-lab

`lattice-lab` is a focused Haskell research tool for finite, rectangular
cellular automata. It includes Conway's Life, HighLife, and Seeds rules,
ASCII import/export, generation streams, and bounded cycle detection. The
library has no runtime dependencies beyond `base`, making experiments easy to
reproduce.

## Run

With GHC and Cabal installed:

```powershell
cabal run lattice-lab -- glider 8
cabal test
```

Patterns use `#` (or `O`) for a live cell and any other character for an empty
cell. `test/golden/blinker.txt` records a stable two-step rendering used by
the test suite. The grid is finite: cells outside its dimensions are not
considered neighbors.

## Scope

This is intentionally a research-sized core rather than a GUI or a simulator
framework. Add rules as `Rule { birth = ..., survive = ... }`, then compose
`step`, `evolve`, and `detectCycle`.

MIT licensed.
