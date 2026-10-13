#!/usr/bin/env bash
# Hermetic tests for scripts/play.sh: fake player + fake macOS idle timer, clean env, temp HOME.
# Run: tests/run.sh   (exit 0 = all pass)
cd "$(dirname "$0")/.." || exit 1
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
mkdir -p "$T/mac" "$T/linux" "$T/home"
# Fake player logs the file it was asked to play ($3 for afplay -v N file).
printf '#!/bin/sh\necho "$3" >> "%s/log"\n' "$T" > "$T/mac/afplay"
printf '#!/bin/sh\necho "  | |   \\"HIDIdleTime\\" = $((IDLE*1000000000))"\n' > "$T/mac/ioreg"
cp "$T/mac/afplay" "$T/linux/afplay" # "linux": a player but no idle timer
chmod +x "$T"/mac/* "$T"/linux/*

fails=0
# play <times> <bin-dir> <idle> <event> [VAR=val ...] -> prints how many clips played
play() {
  local n=$1 bin=$2 idle=$3 event=$4; shift 4
  : > "$T/log"
  for _ in $(seq "$n"); do
    env -i HOME="$T/home" TMPDIR="$T" PATH="$T/$bin:/usr/bin:/bin" IDLE="$idle" "$@" scripts/play.sh "$event"
  done
  sleep 0.2; wc -l < "$T/log" | tr -d ' '
}
expect() { # <label> <min> <max> <actual>
  if [ "$4" -ge "$2" ] && [ "$4" -le "$3" ]; then echo "ok   $1 ($4)"; else echo "FAIL $1 (got $4, want $2..$3)"; fails=$((fails + 1)); fi
}

# Smart mode, surprises off: exact rules.
expect "error always plays"                 20 20 "$(play 20 mac 0   error        NAIJA_SOUND_SURPRISE=0)"
expect "finished while away plays"          20 20 "$(play 20 mac 45  complete     NAIJA_SOUND_SURPRISE=0)"
expect "finished at keyboard is silent"      0  0 "$(play 20 mac 5   complete     NAIJA_SOUND_SURPRISE=0)"
expect "needs-you while away plays"         20 20 "$(play 20 mac 90  notification NAIJA_SOUND_SURPRISE=0)"
expect "needs-you at keyboard is silent"     0  0 "$(play 20 mac 5   notification NAIJA_SOUND_SURPRISE=0)"
for e in start submit precompact session_end; do
  expect "$e is silent"                      0  0 "$(play 10 mac 999 "$e"        NAIJA_SOUND_SURPRISE=0)"
done
expect "custom away threshold"              10 10 "$(play 10 mac 10  complete     NAIJA_SOUND_SURPRISE=0 NAIJA_SOUND_AWAY_AFTER=8)"
expect "mode=all plays everything"          10 10 "$(play 10 mac 0   submit       NAIJA_SOUND_MODE=all)"
expect "mute silences errors too"            0  0 "$(play 10 mac 0   error        NAIJA_SOUND_MUTE=1)"
expect "unknown event is silent"             0  0 "$(play 5  mac 999 nope         NAIJA_SOUND_MODE=all)"

# Random surprises: ~10% by default (wide bounds so CI never flakes).
expect "submit surprise ~10%"               40 180 "$(play 1000 mac 999 submit)"
expect "surprise=100 always"                50 50 "$(play 50 mac 999 start NAIJA_SOUND_SURPRISE=100)"

# No idle timer: fall back to how long the turn took.
date +%s > "$T/claude-naija-turn-start"
expect "no timer, short turn is silent"      0  0 "$(play 10 linux "" complete NAIJA_SOUND_SURPRISE=0)"
echo $(( $(date +%s) - 120 )) > "$T/claude-naija-turn-start"
expect "no timer, 2-min turn plays"         10 10 "$(play 10 linux "" complete NAIJA_SOUND_SURPRISE=0)"
expect "no timer, needs-you plays"          10 10 "$(play 10 linux "" notification NAIJA_SOUND_SURPRISE=0)"

# Your own clips: mixed in, or alone with ONLY_MINE; names with spaces and apostrophes.
mkdir -p "$T/home/.claude/naija-sounds/complete"
cp sounds/submit/sharp-sharp.mp3 "$T/home/.claude/naija-sounds/complete/mummy's clip.mp3"
play 60 mac 99 complete NAIJA_SOUND_SURPRISE=0 >/dev/null
expect "own clip joins the mix"              1 59 "$(grep -c "mummy's clip" "$T/log")"
expect "no back-to-back repeats"             0  0 "$(uniq -d "$T/log" | wc -l | tr -d ' ')"
play 10 mac 99 complete NAIJA_SOUND_ONLY_MINE=1 >/dev/null
expect "ONLY_MINE plays only own clips"     10 10 "$(grep -c "mummy's clip" "$T/log")"
expect "ONLY_MINE + no own clips is silent"  0  0 "$(play 5 mac 99 error NAIJA_SOUND_ONLY_MINE=1)"

# Every event folder in the pack has clips.
for e in start submit complete error notification precompact session_end; do
  expect "pack has $e clips"                 1 99 "$(find "sounds/$e" -name '*.mp3' | wc -l | tr -d ' ')"
done

echo; [ "$fails" -eq 0 ] && echo "ALL PASS" || { echo "$fails FAILED"; exit 1; }
