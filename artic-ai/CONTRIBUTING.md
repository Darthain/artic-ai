# Contributing to ARTIC AI

Thanks for helping. A few rules keep the project healthy and legally clean.

## Licence of contributions
All contributions are accepted under the **GNU General Public License v2.0 only**, the same as the
project ("inbound = outbound"). By opening a pull request you confirm you have the right to submit the code.

## Code from other projects
- **Allowed with notices kept:** GPLv2 (e.g. LAMBS, NR6 HAL, ACE3, CBA) and permissive licences such as BSD/MIT
  (e.g. DCO Soldier FSM). Keep the original copyright line in the file header and add the source to `CREDITS.md`.
- **Never copy:** GPLv3 or AGPL code (e.g. ZEN, ACRE2, IEDD), APL-ND code (e.g. LAFS), or code with no licence.
  Calling those mods' functions at runtime is fine.
- **Clean-room rule:** describe a behaviour in a short design note (plain words, real doctrine) before writing it.

## File headers
Every `.sqf`, `.hpp`, `.cpp` and `.inc` file starts with the ARTIC AI header. Check with:
`python tools/check_headers.py`

## Reporting issues
Open an issue with: what you expected, what happened, the test ID if it relates to a checkpoint (e.g. D3),
the environment (local / dedicated / dedicated + HC), the map, and the RPT files from every machine involved.

## Code style
- Functions: `ARTIC_fnc_<name>` in `addons/core/functions/<area>/fn_<name>.sqf`, with a comment block saying
  what it does, its arguments and its return value.
- Every feature has CBA settings, an on/off switch, debug output prefixed `[ARTIC AI]`, and checkpoint tests.
- Never order a soldier DCO marks as busy (`ARTIC_fnc_unitFree`).

## Building
See `README.md` > Building.
