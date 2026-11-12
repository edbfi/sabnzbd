<p align="center">
  <img src="assets/sabnzbd.svg" alt="sabnzbd logo" width="256">
</p>
<h1 align="center">sabnzbd</h1>
<p align="center"><strong>SABnzbd in a VPN-ready container with bundled ffprobe.</strong></p>
<p align="center">
  <a href="https://github.com/edbfi/sabnzbd/blob/release/LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-blue?style=flat" alt="Image license: GPL-3.0"></a>
  <a href="https://github.com/moby/moby" title="Moby source, the open-source foundation of Docker Engine"><img src="https://img.shields.io/badge/Docker-2496ED?style=flat&amp;logo=docker&amp;logoColor=white" alt="Docker"></a>
  <a href="https://github.com/python/cpython" title="CPython implementation source"><img src="https://img.shields.io/badge/Python-3776AB?style=flat&amp;logo=python&amp;logoColor=white" alt="Python"></a>
  <a href="https://github.com/sabnzbd/sabnzbd" title="SABnzbd source"><img src="https://img.shields.io/badge/SABnzbd-FFB300?style=flat" alt="SABnzbd"></a>
</p>

Based on [hotio/sabnzbd](https://github.com/hotio/sabnzbd), retaining the bundled `ffprobe` customization at `/app/bin/ffprobe`.

[Documentation and examples](https://web.edb.fi/containers/sabnzbd/).

Release, testing and nightly variants target amd64 and arm64. The par2 builder starts from `alpine`, as in hotio/sabnzbd. SABnzbd/par2 source archives are downloaded over HTTPS from their GitHub releases and tags, as in hotio/sabnzbd.

Upstream runtime/configuration/authentication behavior remains unchanged.

Upstream GPL-3.0 image license and application/dependency licenses remain applicable.

Logo reused unchanged from [repo-patches](https://github.com/edbfi/repo-patches/blob/fd7275410c6b160bc9f359a6cf8f729a39ee95ff/hweb-content/assets/img/image-logos/sabnzbd.svg).
