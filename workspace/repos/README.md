# repos/

Repositories cloned for code inspection — the reading agent's local repo bank.

Organized into the same free-form research-area folders as `papers/` (kebab-case). Each repo directory uses the actual upstream repo name, with an id suffix only if two would collide: `repos/<area>/<repo-name>/` — e.g. `repos/spatial-intelligence/TVRBench/`.

A living bank, kept to a working size over time. Clones can be large — shallow-clone (`--depth 1`) where possible. Contents are regenerable and gitignored; this README is tracked to document the layout and keep the directory present on clone.
