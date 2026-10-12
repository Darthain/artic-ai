# ARTIC AI

Open-source AI framework for Arma 3 milsim: battle positions and field defences, section drills, tasks,
a radio-based information network, a commander, and support (logistics, manoeuvre, fires, air and EW),
built on DCO Soldier FSM. **Status: v0.6.8-alpha, Stage 1 (defence) in testing.** Not for live operations yet.

**Repository:** <https://github.com/Darthain/artic-ai> · **Bug reports and suggestions:** <https://github.com/Darthain/artic-ai/issues>

**Licence:** GNU General Public License v2.0 only (`LICENSE`). Copyright (C) 2026 ARTIC AI contributors.
Credits for adapted code and the mods ARTIC works with: `CREDITS.md`. How to contribute: `CONTRIBUTING.md`.

## Requirements
CBA_A3, ACE3, DCO Soldier FSM. Optional: Gruppe Adler Trenches, POOK Camonets, TerrainLib (each feature
falls back cleanly without them).

## Not compatible
**LAMBS Danger** and **VCOM AI** control individual soldiers, which conflicts with DCO Soldier FSM (ARTIC AI's
soldier layer). ARTIC warns admins at mission start if either is loaded. LAMBS Turrets and LAMBS Suppression
are fine (Turrets is checked by test D2).

## Testing (checkpoint test menu)
Turn on **Addon Options > ARTIC AI > Testing > Test menu (admins)**. As the host or a logged-in admin, open ACE
self-interaction > **ARTIC tests** and pick a test; its setup spawns about 90 m in front of you, facing you, and the
result is reported in chat and the RPT (`[ARTIC TEST] ...`). Any small mission works: you, a headless client slot
named `HC` (for E3 tests) and Zeus.

| Entry | Checkpoint test |
| --- | --- |
| D1 / D1h / D1s | Deliberate defence with trenches / hasty defence / support by fire |
| D2 / D2t / D2c | Statics from backpacks (HMG + mortar) / from a truck / ACE CSW items + ammo crate |
| D3 | Sends an attacking squad at the most recent test position (from 400 m, in front of it) |
| D8 | Load test: 4 deliberate positions at once (watch `#monitor`) |
| Status / Clear | Running tests / remove test units and earthworks (DCO positions and dug terrain stay until restart) |

Log each run in the build path's results table.

## Building
1. Install [HEMTT](https://github.com/BrettMayson/HEMTT) (1.13 or later).
2. From the repository root: `hemtt check`, then `hemtt build` (development) or `hemtt release`.
3. The mod is in `.hemttout/build` (or `releases/`).
4. Official releases are signed by the maintainers with the ARTIC key; **never commit private keys**.

Every push is built automatically (`.github/workflows/build.yml`), including the licence-header check.

## Repository layout
- `addons/core/` - the mod: `config.cpp`, `XEH_*.sqf`, `functions/<area>/fn_*.sqf`
- `tools/check_headers.py` - licence header check (checkpoint P2)
- `CREDITS.md`, `CONTRIBUTING.md`, `LICENSE`

---

## Version notes: v0.6.8-alpha
- Admin **test menu** for the Stage 1 checkpoint tests (D1, D2, D3, D8), with automatic result reports.
- Startup warning when LAMBS Danger or VCOM AI is loaded.
- Repository links. No change to AI behaviour from v0.6.7.

## Version notes: v0.6.7-alpha (rebuild foundation + defence testbed)

First build of the ARTIC AI rebuild on **DCO Soldier FSM**. This is a **test build**: it contains the
DCO integration core and the battle-position builder only. The v0.3 commander / ORBAT / support
layers are not ported yet, so **do not load it together with ARTIC AI v0.3**, and don't use it on live ops.

## What it does
**Battle Position / SBF** module (Eden + Zeus, category *ARTIC AI*): a group prepares and occupies
a position facing the module's direction (principal direction of fire):

1. **Plans** fighting-position pairs: a shallow arc with refused wings (defence) or a line sited for
   line of sight to the target area (SBF).
2. **Deploys static weapons**: pairs weapon + tripod backpacks (vanilla) **or ACE crew-served weapon
   items** (weapon + tripod in the launcher slot, ACE "advanced assembly") worn by the group *or
   stored in vehicles / crates within the search radius*, carries them to slots (direct fire on the
   line, mortars 50 m back), assembles and mans them. Empty statics nearby get a crew.
   **Ammo bearers (ACE CSW):** the gunner draws matching CSW ammo from the kit's own vehicle / crate
   (or the nearest container that has some), and the tripod carrier drops any matching ammo he
   carries. It all goes into a cache beside the weapon, inside ACE's 10 m reload reach, before the
   gunner gets in; ACE's AI reload then loads it (ACE CSW "Ammo handling" must include AI). If a
   manned weapon is still empty, default ammo is loaded (setting; turn off to make ammo logistics count).
3. **Digs** GRAD trenches (long for a pair), raised in stages while the pair digs. Sandbags without GRAD.
4. **Conceals** with POOK nets in the terrain's pattern; GRAD terrain camouflage when deliberate.
5. **Occupies**: one **DCO fighting position** per soldier, facing the threat. DCO then fights it.
6. **Sandbags**: round fences in front of static weapons, a ring around mortars, short parapets for
   positions that aren't dug in (setting).
7. **Connects with trenches** (deliberate defence, or "Connect with trenches" = Yes): a fire trench
   behind the positions and a communication trench 45 m to the rear, dug progressively.
8. **Trench fighting positions**: as each stretch is dug, unassigned DCO fighting positions are placed
   every ~6 m (and at every bend): DCO's stepping stones. A threatened soldier dodges to the nearest
   one, so moves stay in the trench; free soldiers and reinforcements are seated in them. Dynamic
   positions at the fire trench's ends (flanks) and the communication trench's rear end activate
   only when an enemy appears in their sector.

ARTIC's own planned moves use the trench route: `[unit, destination] call ARTIC_fnc_moveViaTrench;`
(follows a trench line connecting both ends, else a normal move).

**Trench Line / AT Ditch** module: digs a trench or anti-tank ditch along a route (module position +
synchronised Game Logics / helper objects, chained nearest-first; or a straight line). Method by the
map's terrain grid (`getTerrainInfo select 2`):

| Cell size | Method | Result |
|---|---|---|
| <= 2.5 m | TERRAIN | Real trench dug into the terrain (TerrainLib), ~1.6 m |
| <= 6 m | HYBRID | Sunken lane ~1.0 m (TerrainLib) lined with GRAD trench segments |
| > 6 m, or no TerrainLib | OBJECTS | Chained GRAD trench segments (sandbag walls without GRAD) |
| AT ditch | TerrainLib | ~2.5 m deep, 4 m wide, tank traps if the map has them |

Override per mission: `ARTIC_trenchMethodOverride = "HYBRID";`. Builders (synchronised unit's group)
pause while in combat. Terrain changes are capped by a mission budget (setting).

Control contract: ARTIC only orders soldiers **DCO reports as free**; digging pauses for anyone DCO is
using. ARTIC groups get `SFSM_noAutoStance` so DCO doesn't override their posture.

## v0.6.7 fixes (from the first dedicated test)
- **Digging no longer stops for distant enemies.** Arma switches a group to COMBAT as soon as it
  knows of any enemy; trench building used to pause until COMBAT ended, so with players around the
  soldiers kept the dig animation but no trench ever rose. Building now pauses only if a soldier is
  suppressed, was pinned down in the last 20 s, or a known enemy is within the **Dig safety radius**
  (setting, default 150 m). Debug chat says when and why a trench line pauses / resumes.
- **Ownership settles before building:** with a DCO headless client ("HC"), the module waits (max
  60 s) for the group to move to it, so the build runs on the machine that owns the soldiers.
- Reminder: on a dedicated server the **server's** CBA settings apply (Addon Options > Server tab
  while logged in as admin, or the server's cba_settings.sqf), not the ones from your local tests.

## v0.6.5 fixes
- **Continuous parapet:** trench-line parapets are planned over each whole route segment (long
  GRAD pieces end to end, short ones filling the remainder) and raised stretch by stretch. Before,
  planning per 8 m stretch meant a long piece never fitted: only short pieces with gaps, leaving
  some soldiers digging and fighting with no parapet in front.
- **DCO move.fsm workaround:** "Undefined variable _startPos" (DCO bug when a stalled scripted move
  is re-issued) is prevented by giving every local AI soldier without one a start position
  (v0.6.6: widened from ARTIC groups to all AI, since DCO is no longer maintained upstream).

## v0.6.4: one fire trench through the positions
- **Connected trenches = one fire trench along the position line** (extended 3 m past each end),
  dug by the group before occupation; its parapet is in front and every soldier fights from its
  lane. Pairs no longer dig separate parapets, so there's no second line behind them and no overlaps.
  The communication trench starts from the middle of the line. (Without connected trenches, each
  pair still gets its own parapet.)
- **Spacing by real trench length:** positions are at least a long GRAD trench + 3 m apart, and
  terrain refinement can't pull two positions into each other's footprint.
- **Firing stances raised** so muzzles clear the crest: behind a parapet on flat ground cover prone /
  fire crouch-high; in a lowered lane (HYBRID / TERRAIN) cover crouch-low / fire standing.
- Note: positions finish when the fire trench does; with long lines keep "Trench dig time per 10 m"
  and the preparation time limit in step (default 60 s per 10 m, 600 s limit).

## v0.6.3: soldiers fight BEHIND earthworks, not inside them
AI placed inside GRAD trench models clip, sink when changing stance, pop in and out when peeking,
and can be killed when stepped into overlapping models. So:
- **Fighting positions:** the GRAD trench is the spoil **parapet in front** of the soldier; he digs
  at his own spot (parapet rising in front, like a player) and fights from open ground behind it:
  **prone in cover, crouched to fire** over it.
- **Trench lines:** the parapet runs along the **enemy side** of the route; soldiers and
  stepping-stone positions use the **lane behind it** (lowered terrain on TERRAIN / HYBRID maps).
  Long and short GRAD pieces are fitted to each stretch without overlap, and pieces that would land
  on existing earthworks are skipped (no more pile-ups at junctions).
- **Stepping in** only onto clear ground (moved back up to 3 m), damage off for 3 s.
- **Ground texture** only copied onto trenches when it's a colour texture (fixes purple-white trenches).
- Trench-line positions use stances by lane depth: terrain trench crouch-low/stand, hybrid
  crouch-low/stand-low, flat ground prone/crouch.

## v0.6.2 fixes (from the first local test)
- DCO script error `allowsuppression` undefined (fn_canFipoSuppress): ARTIC's fighting positions now
  set every variable DCO reads without a default.
- Trench models are rotated by their **measured** long axis, so chained segments join end to end
  into a channel instead of overlapping into a solid ridge; segments tilt along the route's slope.
- **Trench model rotation** setting (default 180: GRAD's parapet faces the opposite way).
- Diggers work from **3.5 m behind** their spot, facing it; when finished they **step into** the
  position (setting), then DCO takes over: no one is caught inside a rising trench.
- Connecting trenches are dug at least 6 m / 2 terrain cells behind the positions; DCO fighting
  positions are re-grounded after every terrain pass.

## Headless client
DCO runs on a headless client only if the HC unit is **named `HC`** in the mission (else on the server).
ARTIC warns admins if an HC is connected but unnamed. Fighting positions are registered on whichever
machine runs DCO.

## Testing
1. Load CBA, ACE, **DCO Soldier FSM**, GRAD Trenches, POOK Camonets, **TerrainLib**, and this mod
   (not ARTIC v0.3).
2. Addon Options > ARTIC AI > **Debug** on (map markers + chat log).
3. Place an infantry squad. Give two soldiers static-weapon backpacks (e.g. HMG weapon + tripod),
   and/or put static bags in a nearby truck or crate.
4. Place **Battle Position / SBF**, rotate it to face the threat, **synchronise it to the squad leader**.
5. Play. After ~15 s the squad moves out: statics assembled and manned, pairs dig in, nets go up,
   then DCO takes over the positions. Chat: "DEFENCE battle position READY (...)".
6. Repeat with **Type = Support by fire** on a ridge facing a valley.

Console test (look at a squad leader): `[group cursorObject, "DEFENCE"] call ARTIC_fnc_testBattlePosition;`

**Trench pathing test**: once a trench line is finished (debug chat names its id), move a group
along it point by point: `[group cursorObject, "TL_2_1"] call ARTIC_fnc_testTrenchMove;`
(`keys ARTIC_trenchLines` lists ids; add `true` as a third argument to go in reverse).
Watch whether soldiers stay in the trench or climb out and walk alongside.

## Settings (Addon Options > ARTIC AI)
Debug · digging time scale (deliberate 120 s / hasty 45 s per position) · static search radius ·
static ammo carried per weapon · load default ammo into empty statics · sandbags · preparation time
limit · trench dig time per 10 m · terrain trench depth · trench fighting positions (on/off, spacing, max per
line) · terrain budget.

## Licences
DCO Soldier FSM: BSD 3-Clause (integration calls its public functions). TerrainLib: GPLv2 (called,
not copied: copying its code would make ARTIC GPLv2). GRAD Trenches: APL (called,
not copied). POOK Camonets: objects placed by class. NR6 HAL (GPLv2) and LAFS (APL-ND): concepts only,
no code used.
