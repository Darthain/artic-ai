/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_testBattlePosition: quick console test.
    [group, "DEFENCE" or "SBF", distance ahead m (default 0)] call ARTIC_fnc_testBattlePosition;
    Uses the group leader's position and facing as the principal direction of fire.
    Example (debug console, look at a squad leader):
      [group cursorObject, "DEFENCE"] call ARTIC_fnc_testBattlePosition;
*/
params ["_group", ["_type", "DEFENCE"], ["_ahead", 0]];
private _l = leader _group;
private _c = (getPosATL _l) getPos [_ahead, getDir _l];
[_group, _c, getDir _l, toUpperANSI _type, createHashMap] call ARTIC_fnc_prepareBattlePosition;
