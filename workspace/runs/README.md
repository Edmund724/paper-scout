# runs/

The durable, human-readable record of what each run found.

- `INDEX.md` — the compact coverage log and dedup source of truth (one block per delivered run, newest first).
- `<area>/<title-slug>-<id>-deep-dive.md` — per-paper analysis notes, filed under the same free-form research areas used by `papers/` and `repos/`.

Unlike `papers/`, `repos/`, and `drafts/`, the contents of `runs/` are tracked in git — they are the readable history of the instance. Intermediate scratch (candidate-pool dumps, working DocxXML) does not belong here; it goes in `drafts/`.
