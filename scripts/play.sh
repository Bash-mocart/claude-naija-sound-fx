#!/usr/bin/env bash
# Usage: play.sh <event>  — plays a random clip from sounds/<event>/ in the background.
# NAIJA_SOUND_VOLUME=0..100 (default 60). NAIJA_SOUND_MUTE=1 silences everything.
[ "${NAIJA_SOUND_MUTE:-0}" = "1" ] && exit 0
dir="$(cd "$(dirname "$0")/.." && pwd)/sounds/$1"
files=("$dir"/*.mp3)
[ -e "${files[0]}" ] || exit 0
f="${files[RANDOM % ${#files[@]}]}"
vol="${NAIJA_SOUND_VOLUME:-60}"

if command -v afplay >/dev/null; then
  cmd=(afplay -v "$(awk "BEGIN{print $vol/100}")" "$f")
elif command -v paplay >/dev/null; then
  cmd=(paplay --volume "$((vol * 65536 / 100))" "$f")
elif command -v ffplay >/dev/null; then
  cmd=(ffplay -nodisp -autoexit -loglevel quiet -volume "$vol" "$f")
elif command -v powershell.exe >/dev/null; then # WSL
  cmd=(powershell.exe -c "(New-Object Media.SoundPlayer '$(wslpath -w "$f")').PlaySync()")
else
  exit 0
fi
# ponytail: no SSH relay like claude-sound-fx; add it if remote users ask.
nohup "${cmd[@]}" >/dev/null 2>&1 &
exit 0
