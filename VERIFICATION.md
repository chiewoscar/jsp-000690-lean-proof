# Verification

Run `lake exe cache get` and `python3 scripts/verify.py` from the repository
root (`python3 scripts/verify.py --certificate-only` skips the Lean steps).

The pinned Lean and Mathlib versions are in `lean-toolchain` and
`lake-manifest.json`. The verifier runs a source audit (no `sorry`, `admit`,
`axiom`, `unsafe`, `implemented_by`, `native_decide`), the independent
combinatorial certificate, the Lean build, and the statement/axiom audit.
The recorded results are:

- [`verification/local-lake-build.log`](verification/local-lake-build.log):
  Lean build passed.
- [`verification/local-statement-audit.log`](verification/local-statement-audit.log):
  the audited declarations use only `propext`, `Classical.choice`,
  `Quot.sound`.
- [`verification/status.json`](verification/status.json): all checks passed.

`scripts/check_certificate.py` independently re-verifies, outside Lean, the
facts the kernel checks exhaustively: the 22-edge list is 3-uniform,
δ(H) = 7, H is not 2-colourable, and H − e / H − v are 2-colourable for all
edges e and vertices v.

The GitHub Actions workflow repeats verification on Ubuntu.
