# Claude Naija Sound FX 🇳🇬

Nigerian Pidgin sound effects for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).
Stop staring at the terminal — Mummy go call you when e don finish.

| When | You hear (random, never the same one twice in a row) |
|---|---|
| Session starts | *"Who dey breathe? We don land!"* · *"Oya, gbas gbos! Make we begin."* · *"We move!"* · *"Oya! Ikeja-Obalende, enter with your change o! We dey move!"* · *"Laptop don on, coffee don ready. Make we chop this work!"* |
| You send a prompt | *"Emi lokan! Na my turn now."* · *"Your wish na my command, Chairman."* · *"No wahala!"* · *"Sharp sharp!"* |
| Task finished | *"Omo! E don set!"* · *"Na God o! Work don finish."* · *"E choke!"* · *"Village people don fail! E don finish!"* · *"E don finish! Who be like God? Nobody!"* · *"Ehen! See as you finish am. God bless you, my pikin."* · *"Work done. Na why dem dey call me Chairman."* |
| Claude crashed (network, rate limit, server) | *"Sapa don hold us!"* · *"Ehn ehn! Wetin be this one?"* · *"Na village people!"* · *"Shege! Network don japa!"* · *"Wahala dey o! Wahala be like bicycle."* · *"Ahn ahn! Is it me you are doing this to?"* · *"NEPA don take light!"* |
| Claude needs you (permission, waiting on you) | *"Oga at the top! Approval dey wait you!"* · *"Abeg you dey there? No ghost me o."* · *"Oga, you don japa? I dey wait you o!"* · *"Oga! Oga! Abeg come check something."* · *"If I come there ehn… come here this minute!"* |
| Context compacting | *"Data wan finish. Make I manage am."* · *"Too much gist! Make I summarise."* · *"Body no be firewood!"* · *"Shift! Shift! Four-four for one row!"* · *"Brain don full. Make I pack my load small."* |
| Session ends | *"Bye bye! No forget to off gen!"* · *"Make I sleep before NEPA take light."* · *"I don japa!"* · *"Odabo! Bye bye o! Make una go rest."* · *"I don close shop. If you call me, I no go pick."* |

## Install

```
/plugin marketplace add Bash-mocart/claude-naija-sound-fx
/plugin install claude-naija-sound-fx@claude-naija-sound-fx
```

Restart Claude Code. That's it.

## Smart mode (default)

So it never gets tiring, it only talks when it matters:

| Event | Plays when |
|---|---|
| Claude crashed | Always |
| Task finished · Claude needs you | Only if you've been away — no keyboard/mouse for 30s (macOS idle timer; elsewhere, a turn that took 60s+) |
| Start · prompt sent · compacting · session end | Never — you're right there |

Want every event like a full Nollywood soundtrack? `NAIJA_SOUND_MODE=all`.

## Settings

| Env var | Default | |
|---|---|---|
| `NAIJA_SOUND_MODE` | `smart` | `all` = play on every event |
| `NAIJA_SOUND_AWAY_AFTER` | `30` | seconds without input before you count as away |
| `NAIJA_SOUND_VOLUME` | `60` | 0–100 |
| `NAIJA_SOUND_MUTE` | `0` | `1` = silence (meeting mode) |
| `NAIJA_SOUND_ONLY_MINE` | `0` | `1` = play only your own clips, skip the pack's |

Plays with `afplay` (macOS), `paplay` / `ffplay` (Linux) or PowerShell (WSL).

## Your own sounds (private)

Drop any `.mp3`, `.wav` or `.m4a` into `~/.claude/naija-sounds/<event>/` and it joins the random mix.
Events: `start`, `submit`, `complete`, `error`, `notification`, `precompact`, `session_end`.
That folder lives on your machine only — it survives plugin updates and is never published.

## Add lines to the pack

PRs with more Naija lines welcome (Yoruba, Igbo, Hausa, Warri, Port Harcourt… bring am) —
drop the `.mp3` into `sounds/<event>/`. Only sounds you made or have the rights to.

Voices are AI-generated characters — not real people. Unofficial community plugin, not made by Anthropic.
Inspired by [claude-sound-fx](https://github.com/6m1w/claude-sound-fx).

MIT
