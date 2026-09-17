/-
Copyright (c) 2026 Oscar Chiew. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Oscar Chiew
-/
import Mathlib

/-!
# JSP-000690 — Erdős–Lovász: 3-critical 3-graphs of minimum degree ≥ 7

The catalog problem asks whether a three-uniform, three-chromatic-critical
hypergraph can have minimum degree at least seven (Erdős–Lovász, proposed no
later than 1974). Solved affirmatively by Li, *On an Erdős–Lovász problem:
3-critical 3-graphs of minimum degree 7*, arXiv:2512.24850 (2025).

This file formalizes the statement and proves the classical sharpness
witness: the complete 3-graph `K₅⁽³⁾` on five vertices is 3-chromatic-critical
with every vertex of degree six — the Erdős–Lovász degree-six bound is
attained. The degree-seven construction itself is not formalized.
-/

namespace JSP000690

variable {V : Type*} [DecidableEq V]

/-- `E` is 3-uniform when every edge has exactly three vertices.
`abbrev` so `decide` can unfold it during `Decidable` synthesis. -/
abbrev ThreeUniform (E : Finset (Finset V)) : Prop := ∀ e ∈ E, e.card = 3

/-- A 2-coloring `c` is proper for `E` when every edge sees both colors.
`abbrev` so `decide` can unfold it during `Decidable` synthesis. -/
abbrev ProperTwoColoring (E : Finset (Finset V)) (c : V → Fin 2) : Prop :=
  ∀ e ∈ E, ∃ v ∈ e, ∃ w ∈ e, c v ≠ c w

/-- `E` is 2-colorable when it admits a proper 2-coloring.
`abbrev` so `decide` can unfold it during `Decidable` synthesis. -/
abbrev TwoColorable (E : Finset (Finset V)) : Prop := ∃ c : V → Fin 2, ProperTwoColoring E c

/-- `E` is 3-chromatic-critical: not 2-colorable, but deleting any single edge
restores 2-colorability. -/
def ThreeChromaticCritical (E : Finset (Finset V)) : Prop :=
  ¬ TwoColorable E ∧ ∀ e ∈ E, TwoColorable (E.erase e)

/-- Degree of a vertex: the number of edges containing it. -/
def Degree (v : V) (E : Finset (Finset V)) : ℕ := (E.filter (v ∈ ·)).card

/-- The catalog question JSP-000690: does some 3-uniform, 3-chromatic-critical
hypergraph have minimum degree at least seven? Answered **yes** by Li (2025);
that construction is not formalized here. -/
def JSP000690Question : Prop :=
  ∃ (V : Type) (_ : Fintype V) (_ : DecidableEq V) (E : Finset (Finset V)),
    ThreeUniform E ∧ ThreeChromaticCritical E ∧ ∀ v : V, 7 ≤ Degree v E

section FiveVertexWitness

/-- The vertex set of the five-vertex witness. -/
abbrev Vertex := Fin 5

/-- The complete 3-graph `K₅⁽³⁾`: all ten 3-subsets of `Fin 5`. -/
def edges : Finset (Finset Vertex) := Finset.univ.powersetCard 3

/-- Every edge of `K₅⁽³⁾` has exactly three vertices. -/
theorem edges_uniform : ThreeUniform edges :=
  fun _ he => (Finset.mem_powersetCard.mp he).2

/-- `K₅⁽³⁾` is not 2-colorable: any 2-coloring of five vertices puts at least
three in one class, and that triple is a monochromatic edge. -/
theorem not_two_colorable : ¬ TwoColorable edges := by
  decide

/-- Deleting any edge `e` restores 2-colorability: color `e` with 1 and its
two-vertex complement with 0. Every remaining edge meets both classes. -/
theorem erase_two_colorable : ∀ e ∈ edges, TwoColorable (edges.erase e) := by
  decide

/-- `K₅⁽³⁾` is 3-chromatic-critical. -/
theorem critical : ThreeChromaticCritical edges := ⟨not_two_colorable, erase_two_colorable⟩

/-- Every vertex of `K₅⁽³⁾` lies in `C(4,2) = 6` edges. -/
theorem all_degrees_six : ∀ v : Vertex, Degree v edges = 6 := by
  decide

/-- The minimum degree of `K₅⁽³⁾` is six — sharpness of the degree-six bound. -/
theorem min_degree_six : ∀ v : Vertex, 6 ≤ Degree v edges := fun v => (all_degrees_six v).ge

end FiveVertexWitness

section Transversal

/-- `s` hits `e` when they share a vertex.
`abbrev` so `decide` can unfold it during `Decidable` synthesis. -/
abbrev Hits (s e : Finset Vertex) : Prop := (s ∩ e).Nonempty

/-- `τ(K₅⁽³⁾) = 3`: no set of at most two vertices meets all ten edges —
the complement of any 2-set is itself an edge. -/
theorem no_two_transversal :
    ¬ ∃ s : Finset Vertex, s.card ≤ 2 ∧ ∀ e ∈ edges, Hits s e := by
  decide

/-- Deleting any edge drops the transversal number to two: the two-vertex
complement of the deleted edge hits every remaining edge. -/
theorem transversal_edge_critical :
    ∀ e ∈ edges, ∃ s : Finset Vertex,
      s.card ≤ 2 ∧ ∀ f ∈ edges, f ≠ e → Hits s f := by
  decide

end Transversal

section LiConstruction

/-- Li's 9-vertex example (arXiv:2512.24850, Theorem 1.2). Paper vertex `i`
corresponds to `i - 1 : Fin 9`. The first ten edges contain vertex `0`
(paper vertex 1); the remaining twelve lie in `{1, …, 8}`. -/
def liEdges : Finset (Finset (Fin 9)) :=
  { {0, 1, 2}, {0, 1, 8}, {0, 2, 7}, {0, 3, 5}, {0, 3, 7}, {0, 3, 8},
    {0, 4, 6}, {0, 4, 7}, {0, 4, 8}, {0, 5, 6},
    {1, 2, 5}, {1, 2, 6}, {1, 3, 8}, {1, 4, 8}, {1, 5, 6},
    {2, 3, 7}, {2, 4, 7}, {2, 5, 6}, {3, 5, 7}, {3, 5, 8},
    {4, 6, 7}, {4, 6, 8} }

/-- Li's example is 3-uniform. -/
theorem li_uniform : ThreeUniform liEdges := by
  decide +kernel

/-- Li's example is not 2-colourable: all `2^9 = 512` colourings are checked
directly by the kernel. -/
theorem li_not_two_colorable : ¬ TwoColorable liEdges := by
  decide +kernel

/-- Deleting any edge of Li's example restores 2-colourability
(the paper's Appendix B.1 certificates are found here by enumeration). -/
theorem li_edge_critical : ∀ e ∈ liEdges, TwoColorable (liEdges.erase e) := by
  decide +kernel

/-- Deleting any vertex of Li's example restores 2-colourability: the induced
subhypergraph `H - v` keeps only the edges avoiding `v`. -/
theorem li_vertex_critical :
    ∀ v : Fin 9, TwoColorable (liEdges.filter (v ∉ ·)) := by
  decide +kernel

/-- Li's example is 3-chromatic-critical. -/
theorem li_critical : ThreeChromaticCritical liEdges :=
  ⟨li_not_two_colorable, li_edge_critical⟩

/-- Degrees in Li's example: vertex `0` (paper vertex 1) has degree ten, every
other vertex has degree seven — `δ = 7`. -/
theorem li_min_degree_seven : ∀ v : Fin 9, 7 ≤ Degree v liEdges := by
  decide +kernel

/-- Li's example answers JSP-000690 affirmatively under the chromatic
interpretation: a 3-uniform, 3-chromatic-critical hypergraph with minimum
degree at least seven exists. -/
theorem jsp_000690 : JSP000690Question :=
  ⟨Fin 9, inferInstance, inferInstance, liEdges,
    li_uniform, li_critical, li_min_degree_seven⟩

end LiConstruction

end JSP000690
