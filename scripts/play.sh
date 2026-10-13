#!/usr/bin/env bash
# Usage: play.sh <event>  — plays a random clip from sounds/<event>/ in the background.
# Your own clips in ~/.claude/naija-sounds/<event>/ (mp3/wav/m4a) join the mix; they stay local.
# NAIJA_SOUND_VOLUME=0..100 (default 60). NAIJA_SOUND_MUTE=1 silences everything.
# NAIJA_SOUND_ONLY_MINE=1 skips the pack's clips and plays only yours.
# NAIJA_SOUND_MODE=smart (default): errors always; finished / needs-you only when you've been
#   away NAIJA_SOUND_AWAY_AFTER seconds (default 30); everything else is a surprise that plays
#   NAIJA_SOUND_SURPRISE percent of the time (default 10, 0 = never). =all plays every event.
[ "${NAIJA_SOUND_MUTE:-0}" = "1" ] && exit 0
state="${TMPDIR:-/tmp}/claude-naija"
if [ "${NAIJA_SOUND_MODE:-smart}" != "all" ]; then
  away_after="${NAIJA_SOUND_AWAY_AFTER//[^0-9]/}"; away_after="${away_after:-30}"
  chance="${NAIJA_SOUND_SURPRISE//[^0-9]/}"; chance="${chance:-10}"
  skip() { [ $((RANDOM % 100)) -lt "$chance" ] || exit 0; } # skipped events still win sometimes
  # Seconds since last keyboard/mouse input; empty where we can't tell.
  idle="$(ioreg -c IOHIDSystem 2>/dev/null | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')"
  # ponytail: one global turn timer, so parallel sessions can share it; per-session if that misleads.
  [ "$1" = "submit" ] && date +%s > "$state-turn-start" 2>/dev/null
  case "$1" in
    error) ;;
    complete)
      if [ -n "$idle" ]; then [ "$idle" -ge "$away_after" ] || skip
      else started="$(cat "$state-turn-start" 2>/dev/null)"; [ $(( $(date +%s) - ${started:-0} )) -ge 60 ] || skip; fi ;;
    notification) [ -z "$idle" ] || [ "$idle" -ge "$away_after" ] || skip ;;
    *) skip ;;
  esac
fi
shopt -s nullglob
mine="$HOME/.claude/naija-sounds/$1"
files=("$mine"/*.mp3 "$mine"/*.wav "$mine"/*.m4a)
[ "${NAIJA_SOUND_ONLY_MINE:-0}" = "1" ] || files+=("$(cd "$(dirname "$0")/.." && pwd)/sounds/$1"/*.mp3)
[ "${#files[@]}" -gt 0 ] || exit 0
# NAIJA_SOUND_PREFER=word: if any clip's filename contains it (any case), only those play.
if [ -n "${NAIJA_SOUND_PREFER:-}" ]; then
  shopt -s nocasematch; fav=()
  for x in "${files[@]}"; do [[ "$(basename "$x")" == *"$NAIJA_SOUND_PREFER"* ]] && fav+=("$x"); done
  shopt -u nocasematch; [ "${#fav[@]}" -gt 0 ] && files=("${fav[@]}")
fi
# Random pick, never the same clip twice in a row for this event.
last_file="$state-last-$1"
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
elif command -v powershell.exe >/dev/null; then # WSL / Git Bash; SoundPlayer is wav-only, MediaPlayer does mp3
  win="$(wslpath -w "$f" 2>/dev/null || cygpath -w "$f" 2>/dev/null || echo "$f")"
  win="${win//\'/\'\'}" # escape ' for the PowerShell string
  cmd=(powershell.exe -NoProfile -c "Add-Type -AssemblyName PresentationCore; \$p=New-Object System.Windows.Media.MediaPlayer; \$p.Volume=$vol/100; \$p.Open([uri]'$win'); \$p.Play(); Start-Sleep 8")
else
  exit 0
fi
# ponytail: no SSH relay like claude-sound-fx; add it if remote users ask.
[ "${NAIJA_SOUND_SYNC:-0}" = "1" ] && exec "${cmd[@]}" </dev/null >/dev/null 2>&1 # demo: wait for it
nohup "${cmd[@]}" </dev/null >/dev/null 2>&1 &
exit 0
