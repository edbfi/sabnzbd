# SABnzbd container

Based on [hotio/sabnzbd](https://github.com/hotio/sabnzbd), retaining the bundled `ffprobe` customization at `/app/bin/ffprobe`.

[Documentation and examples](https://web.edb.fi/containers/sabnzbd/).

Release, testing and nightly variants are built and smoke-tested on amd64 and arm64 and published on every push to their branch. The par2 builder starts from `alpine`, as in hotio/sabnzbd. SABnzbd/par2 source archives are downloaded over HTTPS from GitHub, as in hotio/sabnzbd; the operating-system package inventory is retained by CI in `packages.txt`.

CI checks that the web UI answers on port 8080 when the container starts without configuration. Live Usenet/VPN connections require separate integration validation. Upstream runtime/configuration/authentication behavior remains unchanged.

Upstream GPL-3.0 image license and application/dependency licenses remain applicable.
