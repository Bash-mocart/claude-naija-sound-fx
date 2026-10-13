#!/usr/bin/env bash
# Plays one clip per event, one after another, so you can hear the pack right now.
# Ignores smart mode; respects mute, volume and NAIJA_SOUND_ONLY_MINE.
here="$(cd "$(dirname "$0")" && pwd)"
[ "${NAIJA_SOUND_MUTE:-0}" = "1" ] && { echo "Muted — unset NAIJA_SOUND_MUTE to hear it."; exit 0; }
while read -r event label; do
  echo "▶ $label"
  NAIJA_SOUND_MODE=all NAIJA_SOUND_SYNC=1 "$here/play.sh" "$event"
done <<'LIST'
start Session starts
submit You send a prompt
complete Task finished
error Claude crashed
notification Claude needs you
precompact Context compacting
session_end Session ends
LIST
echo "E don finish! 🇳🇬"
