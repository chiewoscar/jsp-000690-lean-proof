# JSP-000690 Lean proof

Lean 4 proof answering JSP-000690 (Erdős–Lovász) affirmatively under the
chromatic interpretation: *a three-uniform, three-chromatic-critical
hypergraph with minimum degree at least seven exists.*

The main result is `JSP000690.jsp_000690` in
[`JSP000690/Basic.lean`](JSP000690/Basic.lean): Li's explicit 9-vertex
3-graph (arXiv:2512.24850, Theorem 1.2) is kernel-verified to be
3-uniform, not 2-colourable, edge- and vertex-critical, with minimum
degree seven. The classical `K₅⁽³⁾` degree-six witness is also formalized.
See [`STATEMENT.md`](STATEMENT.md) for the correspondence with the catalog
question.

## Verify

```bash
lake exe cache get
python3 scripts/verify.py
```
