#!/usr/bin/env bash
# Makes the release files in dist/release/: displays_all.deb and SHA256SUMS (signed later, locally, with
# icenux-app-sign-upload.sh; the signing key never reaches GitHub).
#
# Usage: bash packaging/package.sh VERSION     (needs nfpm in PATH; VERSION must match VERSION in ./displays)
set -euo pipefail
umask 022
cd "$(dirname "$0")/.."

VERSION=${1:?usage: packaging/package.sh VERSION}
export VERSION
built=$(sed -n 's/^VERSION="\(.*\)"/\1/p' displays | head -1)
[ "$built" = "$VERSION" ] || { echo "Version in displays ($built) != $VERSION" >&2; exit 1; }
out=dist/release
rm -rf "$out" && mkdir -p "$out"

nfpm package --config packaging/nfpm.yaml --packager deb --target "$out/displays_all.deb"
(cd "$out" && sha256sum displays_all.deb > SHA256SUMS)
ls -l "$out"
