#!/usr/bin/env bash
set -euo pipefail
image="$1"
evidence="$2"
bash tools/base-smoke.sh "$image" "$evidence"
docker run --rm --entrypoint python3 "$image" -m pip check > "$evidence/python-check.txt"
docker run --rm --entrypoint python3 "$image" -m pip freeze > "$evidence/python-packages.txt"
docker run --rm --entrypoint sh "$image" -ec '
  ffmpeg -v error -f lavfi -i sine=frequency=1000:sample_rate=8000 -t 1 /tmp/test.wav
  /app/bin/ffprobe -v error -show_streams -of json /tmp/test.wav
' > "$evidence/ffprobe.json"
jq -e '.streams[0].codec_type == "audio" and .streams[0].sample_rate == "8000"' "$evidence/ffprobe.json"
docker run --rm --entrypoint sh "$image" -ec '
  dd if=/dev/zero of=/tmp/data.bin bs=1024 count=64 2>/dev/null
  cp /tmp/data.bin /tmp/expected.bin
  par2 create -q -r20 /tmp/repair.par2 /tmp/data.bin
  printf x | dd of=/tmp/data.bin bs=1 conv=notrunc 2>/dev/null
  ! cmp -s /tmp/data.bin /tmp/expected.bin
  par2 repair -q /tmp/repair.par2
  cmp /tmp/data.bin /tmp/expected.bin
' > "$evidence/par2-repair.txt"
name="sabnzbd-smoke-${GITHUB_RUN_ID:-local}-${RANDOM}"
cleanup() {
  docker logs "$name" > "$evidence/sabnzbd.log" 2>&1 || true
  docker rm -f "$name" >/dev/null 2>&1 || true
}
trap cleanup EXIT
docker run --detach --name "$name" --tmpfs /config -e VPN_ENABLED=false "$image"
ready=false
for _ in {1..90}; do
  if docker exec "$name" curl -fsSL http://127.0.0.1:8080/ > "$evidence/http.html"; then ready=true; break; fi
  sleep 1
done
test "$ready" = true
grep -qi sabnzbd "$evidence/http.html"
# Read the generated API key only inside the disposable container.
# Do not copy configuration or credentials into the evidence.
for mode in version queue; do
  docker exec "$name" sh -ec '
    key=$(python3 -c '\''from configobj import ConfigObj; print(ConfigObj("/config/sabnzbd.ini")["misc"]["api_key"])'\'')
    curl -fsS "http://127.0.0.1:8080/api?mode=$1&output=json&apikey=$key"
  ' sh "$mode" > "$evidence/api-$mode.json"
done
expected=$(jq -r .app_version meta.json)
jq -e --arg v "$expected" '.version | startswith($v)' "$evidence/api-version.json"
jq -e '.queue.slots == []' "$evidence/api-queue.json"
docker exec "$name" sh -ec 'test "$(stat -c %u /config/sabnzbd.ini)" = 1000'
printf 'SABnzbd API/version/empty queue, ffprobe media inspection, PAR2 repair, Python dependencies and ownership passed.\n' >> "$evidence/result.txt"
