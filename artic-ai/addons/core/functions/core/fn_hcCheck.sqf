/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_hcCheck (server): warns if a headless client is connected but DCO will not use it.
    DCO runs on a headless client only when the HC unit is named "HC" (or PR_HC1 is set).
*/
if (!isServer || {!(call ARTIC_fnc_hasDco)}) exitWith {};
private _hcs = (entities "HeadlessClient_F") select { isPlayer _x };
if (_hcs isNotEqualTo [] && {isNil {missionNamespace getVariable "PR_HC1"}}) then {
    private _msg = "A headless client is connected but DCO is not using it: name the HC unit 'HC' in the mission so DCO runs there.";
    [_msg, "WARN"] call ARTIC_fnc_log;
    ["ARTIC_adminMessage", [_msg]] call CBA_fnc_globalEvent;
};
