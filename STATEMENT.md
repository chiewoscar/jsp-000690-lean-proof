# Statement correspondence

## Catalog question

> Is there a three-uniform, three-chromatic-critical hypergraph with minimum
> degree at least seven?

Status in the catalog: **Solved** — Li, *On an Erdős–Lovász problem: 3-critical
3-graphs of minimum degree 7*, arXiv:2512.24850 (2025). The answer is yes.

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
"3-chromatic-critical" is taken in the edge-critical sense: chromatic number
three (not 2-colorable), and deleting any single edge drops it to 2-colorable.

## The question as a Prop

```lean
def JSP000690Question : Prop :=
  ∃ (V : Type) (_ : Fintype V) (_ : DecidableEq V) (E : Finset (Finset V)),
    ThreeUniform E ∧ ThreeChromaticCritical E ∧ ∀ v : V, 7 ≤ Degree v E
```

Li's construction proving this Prop is not formalized.

## What is proved here (the degree-six witness)

For `edges := Finset.univ.powersetCard 3` over `Fin 5` (the complete 3-graph
`K₅⁽³⁾`, ten edges):

| Statement | Meaning |
| --- | --- |
| `edges_uniform` | `K₅⁽³⁾` is 3-uniform |
| `not_two_colorable` | χ > 2: every 2-coloring has a monochromatic edge |
| `erase_two_colorable` | deleting any edge restores 2-colorability |
| `critical` | `K₅⁽³⁾` is 3-chromatic-critical |
| `all_degrees_six` | every vertex has degree `C(4,2) = 6` |
| `no_two_transversal` | τ = 3 in the transversal formulation |
| `transversal_edge_critical` | deleting any edge drops τ to 2 |

`K₅⁽³⁾` attains degree six, so the answer to the catalog question cannot be
ruled out by the degree-six bound alone; the general degree-seven example is
Li's theorem.
