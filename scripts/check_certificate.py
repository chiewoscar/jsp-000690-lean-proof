#!/usr/bin/env python3
"""Independent certificate for Li's 9-vertex hypergraph (arXiv:2512.24850).

Pure Python 3, standard library only. Exhaustively verifies the same facts the
Lean kernel proves in JSP000690/Basic.lean: 3-uniformity, delta = 7,
non-2-colourability, edge-criticality and vertex-criticality.
Paper vertex i corresponds to i - 1 here and in the Lean source.
"""
from itertools import product

V = list(range(9))
E = [
    (0, 1, 2), (0, 1, 8), (0, 2, 7), (0, 3, 5), (0, 3, 7), (0, 3, 8),
    (0, 4, 6), (0, 4, 7), (0, 4, 8), (0, 5, 6),
    (1, 2, 5), (1, 2, 6), (1, 3, 8), (1, 4, 8), (1, 5, 6),
    (2, 3, 7), (2, 4, 7), (2, 5, 6), (3, 5, 7), (3, 5, 8),
    (4, 6, 7), (4, 6, 8),
]


def is_proper(col, edges):
    return all(len({col[v] for v in e}) == 2 for e in edges)


def two_colorable(edges):
    return any(is_proper(col, edges) for col in product((0, 1), repeat=9))


assert len(E) == 22 and all(len(e) == 3 for e in E), "edge list is not 3-uniform"
deg = {v: sum(v in e for e in E) for v in V}
assert min(deg.values()) == 7 and deg[0] == 10, f"degree check failed: {deg}"
assert not two_colorable(E), "H is 2-colourable"
for e in E:
    rest = [f for f in E if f != e]
    assert two_colorable(rest), f"H-e not 2-colourable for e={e}"
for v in V:
    rest = [f for f in E if v not in f]
    assert two_colorable(rest), f"H-v not 2-colourable for v={v}"

print("certificate: PASS (3-uniform, delta=7, not 2-colourable, "
      "edge- and vertex-critical)")
