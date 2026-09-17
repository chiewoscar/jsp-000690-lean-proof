# Statement correspondence

## Catalog question

> Is there a three-uniform, three-chromatic-critical hypergraph with minimum
> degree at least seven?

Status in the catalog: **Solved** — Li, *On an Erdős–Lovász problem: 3-critical
3-graphs of minimum degree 7*, arXiv:2512.24850 (2025). The answer is yes.

Li notes the original problem does not specify what "3-critical" means and
resolves it under both non-equivalent interpretations:

- **Transversal interpretation** — τ(H) = 3 with τ(H−e) = 2 for every edge e
  forces |E(H)| ≤ 10 and hence δ(H) ≤ 6, sharp via `K₅⁽³⁾` (Theorem 1.1, a
  negative answer there).
- **Chromatic interpretation** — an explicit 3-graph on 9 vertices is
  critically 3-chromatic under weak colourings with δ = 7 (Theorem 1.2, the
  positive answer to the catalog question).

## Formal predicates

In `JSP000690/Basic.lean`, over a finite vertex type `V`:

```lean
ThreeUniform E           := ∀ e ∈ E, e.card = 3
ProperTwoColoring E c    := ∀ e ∈ E, ∃ v ∈ e, ∃ w ∈ e, c v ≠ c w
TwoColorable E           := ∃ c : V → Fin 2, ProperTwoColoring E c
ThreeChromaticCritical E := ¬ TwoColorable E ∧ ∀ e ∈ E, TwoColorable (E.erase e)
Degree v E               := (E.filter (v ∈ ·)).card
```

A hypergraph edge is a `Finset V`; the edge set is `Finset (Finset V)`.
"3-chromatic-critical" is taken in the edge-critical sense: not 2-colourable,
and deleting any single edge restores 2-colourability. These are the standard
weak-colouring notions of the paper (Section 2.2).

## The question as a Prop, and the main theorem

```lean
def JSP000690Question : Prop :=
  ∃ (V : Type) (_ : Fintype V) (_ : DecidableEq V) (E : Finset (Finset V)),
    ThreeUniform E ∧ ThreeChromaticCritical E ∧ ∀ v : V, 7 ≤ Degree v E

theorem jsp_000690 : JSP000690Question
```

`jsp_000690` instantiates the existential with `V := Fin 9` and Li's explicit
edge set `liEdges` (paper vertex `i` ↔ `i - 1 : Fin 9`). All properties are
proved by kernel-checked `decide +kernel` — exhaustive verification, no
certificates taken on trust. Axiom dependencies: `propext`,
`Classical.choice`, `Quot.sound` only (see `verification/`).

## What is proved

| Statement | Meaning |
| --- | --- |
| `li_uniform` | the 22 listed edges are all 3-subsets |
| `li_not_two_colorable` | no proper 2-colouring exists (all 512 checked) |
| `li_edge_critical` | `H − e` is 2-colourable for every edge e |
| `li_vertex_critical` | `H − v` is 2-colourable for every vertex v |
| `li_critical` | `H` is 3-chromatic-critical |
| `li_min_degree_seven` | `δ(H) = 7` (vertex 0 has degree 10, the rest 7) |
| **`jsp_000690`** | **the catalog question, proved affirmatively** |

## The `K₅⁽³⁾` degree-six witness (transversal sharpness)

For `edges := Finset.univ.powersetCard 3` over `Fin 5`:

| Statement | Meaning |
| --- | --- |
| `edges_uniform` | `K₅⁽³⁾` is 3-uniform |
| `not_two_colorable` | χ > 2 |
| `erase_two_colorable` | deleting any edge restores 2-colourability |
| `critical` | `K₅⁽³⁾` is 3-chromatic-critical |
| `all_degrees_six` | every vertex has degree `C(4,2) = 6` |
| `no_two_transversal` | τ = 3 in the transversal reading |
| `transversal_edge_critical` | deleting any edge drops τ to 2 |

## Not formalized

Theorem 1.1's general bound (every τ-critical-of-order-3 3-graph has
|E| ≤ 10, via Bollobás's set-pairs inequality) is stated contextually but not
formalized; it is not needed for the affirmative answer to the catalog
question, which the 9-vertex example settles directly.
