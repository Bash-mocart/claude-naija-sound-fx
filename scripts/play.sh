#!/usr/bin/env bash
# Usage: play.sh <event>  — plays a random clip from sounds/<event>/ in the background.
# NAIJA_SOUND_VOLUME=0..100 (default 60). NAIJA_SOUND_MUTE=1 silences everything.
[ "${NAIJA_SOUND_MUTE:-0}" = "1" ] && exit 0
dir="$(cd "$(dirname "$0")/.." && pwd)/sounds/$1"
files=("$dir"/*.mp3)
[ -e "${files[0]}" ] || exit 0
# Random pick, never the same clip twice in a row for this event.
last_file="${TMPDIR:-/tmp}/claude-naija-last-$1"
last="$(cat "$last_file" 2>/dev/null)"
pool=(); for x in "${files[@]}"; do [ "$x" != "$last" ] && pool+=("$x"); done
[ "${#pool[@]}" -eq 0 ] && pool=("${files[@]}")
f="${pool[RANDOM % ${#pool[@]}]}"
echo "$f" > "$last_file" 2>/dev/null
vol="${NAIJA_SOUND_VOLUME//[^0-9]/}"; vol="${vol:-60}"; [ "$vol" -gt 100 ] && vol=100

if command -v afplay >/dev/null; then
  cmd=(afplay -v "$(awk "BEGIN{print $vol/100}")" "$f")
elif command -v ffplay >/dev/null; then # before paplay: older paplay can't decode mp3
  cmd=(ffplay -nodisp -autoexit -loglevel quiet -volume "$vol" "$f")
elif command -v paplay >/dev/null; then
  cmd=(paplay --volume "$((vol * 65536 / 100))" "$f")
elif command -v powershell.exe >/dev/null; then # WSL; SoundPlayer is wav-only, MediaPlayer does mp3
  cmd=(powershell.exe -NoProfile -c "Add-Type -AssemblyName PresentationCore; \$p=New-Object System.Windows.Media.MediaPlayer; \$p.Volume=$vol/100; \$p.Open([uri]'$(wslpath -w "$f")'); \$p.Play(); Start-Sleep 8")
else
  exit 0
fi
# ponytail: no SSH relay like claude-sound-fx; add it if remote users ask.
nohup "${cmd[@]}" </dev/null >/dev/null 2>&1 &
exit 0
