# SABnzbd container

Based on [hotio/sabnzbd](https://github.com/hotio/sabnzbd), retaining the bundled `ffprobe` customization at `/app/bin/ffprobe`.

[Documentation and examples](https://web.edb.fi/containers/sabnzbd/).

Release, testing and pinned nightly variants target amd64 and arm64. The par2 builder uses the same pinned Alpine base as the runtime. SABnzbd/par2 source archives are SHA-256 checked.

Upstream runtime/configuration/authentication behavior remains unchanged.

Upstream GPL-3.0 image license and application/dependency licenses remain applicable.
