# SABnzbd container

Based on [hotio/sabnzbd](https://github.com/hotio/sabnzbd), retaining the bundled `ffprobe` customization at `/app/bin/ffprobe`.

[Documentation and examples](https://web.edb.fi/containers/sabnzbd/).

Release, testing and pinned nightly variants are validated natively on amd64 and arm64 before manual publication. The par2 builder uses the same pinned Alpine base as the runtime. SABnzbd/par2 source archives are SHA-256 checked; Python dependency and operating-system package inventories are retained by CI.

CI checks web/API startup, version, configuration ownership, actual media probing and a PAR2 create/repair round trip. Live Usenet/VPN connections require separate integration validation. Upstream runtime/configuration/authentication behavior remains unchanged.

Upstream GPL-3.0 image license and application/dependency licenses remain applicable.

Shared CI and Renovate presets use automation `v4.0.0`. Renovate owns dependency
PR merging through the shared `automerge.json` preset: it arms GitHub auto-merge
with the rebase strategy, preserving commit author sign-offs, and GitHub merges
only after every required check passes. Strict, GitHub Actions-sourced required
CI and PR policy checks must pass on an up-to-date branch; the automated merger
has no bypass. The read-only PR policy check preserves sign-offs, Conventional
Commit titles, reviews and hold labels. Independent policy events run to
completion without cancelling one another; after a pass, policy re-runs the other
event's older failed verdict for the same head. The shared release-age policy
remains active, and Renovate configuration updates require manual merging. The
custom checked merger remains retired.
Native architecture builds and every existing container smoke assertion remain
mandatory; image publication remains an explicit manual operation after CI.
