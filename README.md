# naija-sound-fx 🇳🇬

Nigerian Pidgin sound effects for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).
Stop staring at the terminal — Mummy go call you when e don finish.

| When | You hear (random pick) |
|---|---|
| Session starts | *"Oya! Ikeja-Obalende, enter with your change o! We dey move!"* · *"Laptop don on, coffee don ready. Make we chop this work!"* |
| You send a prompt | *"Sharp sharp!"* |
| Task finished | *"E don finish! Who be like God? Nobody!"* · *"Ehen! See as you finish am. God bless you, my pikin."* · *"Work done. Na why dem dey call me Chairman."* |
| Claude crashed (network, rate limit, server) | *"Wahala dey o! Wahala be like bicycle."* · *"Ahn ahn! Is it me you are doing this to?"* · *"NEPA don take light!"* |
| Claude needs you (permission, waiting on you) | *"Oga! Oga! Abeg come check something."* · *"If I come there ehn… come here this minute!"* |
| Context compacting | *"Shift! Shift! Four-four for one row!"* · *"Brain don full. Make I pack my load small."* |
| Session ends | *"Odabo! Bye bye o! Make una go rest."* · *"I don close shop. If you call me, I no go pick."* |

## Install

```
/plugin marketplace add Bash-mocart/naija-sound-fx
/plugin install naija-sound-fx@naija-sound-fx
```

Restart Claude Code. That's it.

## Settings

| Env var | Default | |
|---|---|---|
| `NAIJA_SOUND_VOLUME` | `60` | 0–100 |
| `NAIJA_SOUND_MUTE` | `0` | `1` = silence (meeting mode) |

Plays with `afplay` (macOS), `paplay` / `ffplay` (Linux) or PowerShell (WSL).

## Add your own lines

Drop any `.mp3` into `sounds/<event>/` — `start`, `submit`, `complete`, `error`,
`notification`, `precompact`, `session_end`. One is picked at random. No code changes.
PRs with more Naija lines welcome (Yoruba, Igbo, Hausa, Warri, Port Harcourt… bring am).

Voices are AI-generated characters — not real people.
Inspired by [claude-sound-fx](https://github.com/6m1w/claude-sound-fx).

MIT
