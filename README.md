# JSP-000690 Lean statement + witness

Lean 4 formalization of JSP-000690 (Erdős–Lovász): *is there a three-uniform,
three-chromatic-critical hypergraph with minimum degree at least seven?*

Solved affirmatively by Li (arXiv:2512.24850, 2025). This project formalizes
the statement (`JSP000690Question` in `JSP000690/Basic.lean`) and proves the
classical sharpness witness: the complete 3-graph `K₅⁽³⁾` is
3-chromatic-critical with minimum degree six.

See [`STATEMENT.md`](STATEMENT.md) for the correspondence with the catalog
question. Li's degree-seven construction is not formalized.

## Verify

```bash
lake exe cache get
lake build
```
