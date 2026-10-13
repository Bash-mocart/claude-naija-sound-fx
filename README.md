# Naija Sound FX for Claude Code 🇳🇬

[![CI](https://github.com/Bash-mocart/claude-naija-sound-fx/actions/workflows/ci.yml/badge.svg)](https://github.com/Bash-mocart/claude-naija-sound-fx/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
![Platforms](https://img.shields.io/badge/macOS%20%7C%20Linux%20%7C%20Windows-supported-blue)

Nigerian Pidgin sound effects for [Claude Code](https://code.claude.com). Stop staring at the terminal —
when Claude finishes, crashes, or needs you, a Naija voice go call you.

> *"E don finish! Who be like God? Nobody!"* · *"NEPA don take light!"* · *"Oga at the top! Approval dey wait you!"*

<!-- Demo video: drag an .mp4 onto this README in the GitHub editor and it will embed here. -->

## Install

In Claude Code:

```
/plugin marketplace add Bash-mocart/claude-naija-sound-fx
/plugin install naija-sound-fx@naija-sound-fx
```

Restart Claude Code, then hear it straight away:

```
/naija-sound-fx:demo
```

That plays one sound for every event. No dependencies — it uses your system's audio player.

## Smart mode — it won't tire you

By default it only talks when it matters:

| What happened | When you hear it |
|---|---|
| Claude crashed (network, rate limit, server error) | **Always** |
| Task finished · Claude needs your approval | **Only if you've stepped away** — no keyboard or mouse for 30s |
| Session start · prompt sent · compacting · session end | **Rarely** — a random surprise about 1 time in 10 |

So while you're typing it stays quiet, and when you go make tea it tells you the work is done.
Clips are random and never repeat back-to-back.

Want the full Nollywood soundtrack on every event? Set `NAIJA_SOUND_MODE=all`.

## What you'll hear

38 lines from a cast of characters — a danfo conductor, a Nigerian mum, a Chairman, a rally speaker.
[▶ Listen to all of them](sampler.mp3)

<details>
<summary>Every line, by event</summary>

| Event | Lines |
|---|---|
| Session starts | "Who dey breathe? We don land!" · "Oya, gbas gbos! Make we begin." · "We move!" · "Oya! Ikeja-Obalende, enter with your change o!" · "Laptop don on, coffee don ready. Make we chop this work!" |
| Prompt sent | "Emi lokan! Na my turn now." · "Your wish na my command, Chairman." · "No wahala!" · "Sharp sharp!" |
| Task finished | "E don finish! Who be like God? Nobody!" · "Omo! E don set!" · "Na God o! Work don finish." · "E choke!" · "Village people don fail! E don finish!" · "Ehen! See as you finish am. God bless you, my pikin." · "Work done. Na why dem dey call me Chairman." |
| Claude crashed | "NEPA don take light!" · "Sapa don hold us!" · "Wahala dey o! Wahala be like bicycle." · "Na village people!" · "Shege! Network don japa!" · "Ehn ehn! Wetin be this one?" · "Ahn ahn! Is it me you are doing this to?" |
| Claude needs you | "Oga at the top! Approval dey wait you!" · "Oga! Oga! Abeg come check something." · "Abeg you dey there? No ghost me o." · "Oga, you don japa? I dey wait you o!" · "If I come there ehn… come here this minute!" |
| Compacting | "Brain don full. Make I pack my load small." · "Body no be firewood!" · "Data wan finish. Make I manage am." · "Too much gist! Make I summarise." · "Shift! Shift! Four-four for one row!" |
| Session ends | "I don japa!" · "Bye bye! No forget to off gen!" · "Make I sleep before NEPA take light." · "Odabo! Bye bye o! Make una go rest." · "I don close shop. If you call me, I no go pick." |

</details>

## Settings

Add any of these to the `env` block of `~/.claude/settings.json`, then restart Claude Code:

```json
{
  "env": {
    "NAIJA_SOUND_VOLUME": "40",
    "NAIJA_SOUND_AWAY_AFTER": "60"
  }
}
```

| Variable | Default | What it does |
|---|---|---|
| `NAIJA_SOUND_VOLUME` | `60` | Volume, 0–100 |
| `NAIJA_SOUND_MODE` | `smart` | `all` plays on every event |
| `NAIJA_SOUND_AWAY_AFTER` | `30` | Seconds without input before you count as "away" |
| `NAIJA_SOUND_SURPRISE` | `10` | % chance a skipped event plays anyway (`0` = never) |
| `NAIJA_SOUND_MUTE` | `0` | `1` = silence everything (meeting mode) |
| `NAIJA_SOUND_ONLY_MINE` | `0` | `1` = play only your own clips (below) |
| `NAIJA_SOUND_PREFER` | — | A word, e.g. `mummy`: when an event has a clip whose filename contains it, that clip always plays |

## Use your own sounds

Drop `.mp3`, `.wav` or `.m4a` files into `~/.claude/naija-sounds/<event>/` and they join the mix.
Events: `start`, `submit`, `complete`, `error`, `notification`, `precompact`, `session_end`.

That folder stays on your machine, survives plugin updates, and is never published.

## Troubleshooting

**I don't hear anything.** That's usually smart mode doing its job: it's quiet while you're at the keyboard.
Run `/naija-sound-fx:demo` — if that plays, everything works. If it doesn't:

- Check `NAIJA_SOUND_MUTE` isn't `1` and your system volume is up.
- **Linux:** install a player — `sudo apt install ffmpeg` (for `ffplay`) or PulseAudio's `paplay`.
- **Windows:** works in WSL and Git Bash through PowerShell.
- **Over SSH:** sounds play on the remote machine, not your laptop.

**It's too much.** Raise `NAIJA_SOUND_AWAY_AFTER`, set `NAIJA_SOUND_SURPRISE=0`, or lower the volume.

## Update or uninstall

```
/plugin marketplace update naija-sound-fx
/plugin uninstall naija-sound-fx@naija-sound-fx
```

## How it works

Claude Code [hooks](https://code.claude.com/docs/en/hooks) call one small script, `scripts/play.sh`, on seven events:
`SessionStart`, `UserPromptSubmit`, `Stop`, `StopFailure`, `Notification`, `PreCompact` and `SessionEnd`.
"Away" comes from the macOS idle timer (no permissions needed); on Linux and Windows it falls back to
how long the task took. Playback uses `afplay`, `ffplay`, `paplay` or PowerShell — whichever you have.

## Contributing

More lines welcome — Yoruba, Igbo, Hausa, Warri, Port Harcourt… bring am. Add an `.mp3` to `sounds/<event>/`
(only sounds you made or have the rights to), run `tests/run.sh`, and open a PR.

## Credits

Voices are AI-generated characters, not real people. Catchphrases are Nigerian internet culture.
Inspired by [claude-sound-fx](https://github.com/6m1w/claude-sound-fx).

Unofficial community plugin — not made by or affiliated with Anthropic. MIT licensed.
