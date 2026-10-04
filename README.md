# SABnzbd container

Based on [hotio/sabnzbd](https://github.com/hotio/sabnzbd), retaining the bundled `ffprobe` customization at `/app/bin/ffprobe`.

[Documentation and examples](https://web.edb.fi/containers/sabnzbd/).

Release, testing and nightly variants target amd64 and arm64. The par2 builder starts from `alpine`, as in hotio/sabnzbd. SABnzbd/par2 source archives are downloaded over HTTPS from their GitHub releases and tags, as in hotio/sabnzbd.

Upstream runtime/configuration/authentication behavior remains unchanged.

Upstream GPL-3.0 image license and application/dependency licenses remain applicable.
