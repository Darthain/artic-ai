/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_conflictCheck (server): warns admins about mods that conflict with ARTIC AI's soldier
    layer (DCO Soldier FSM controls individual soldiers; these mods do too). Notes mods that need a
    specific check rather than removal.
*/
if (!isServer) exitWith {};
{
    _x params ["_patch", "_name"];
    if (isClass (configFile >> "CfgPatches" >> _patch)) then {
        private _msg = format ["%1 is loaded: it controls individual AI soldiers, which conflicts with DCO Soldier FSM (ARTIC AI's soldier layer). Remove it from the modpack.", _name];
        [_msg, "WARN"] call ARTIC_fnc_log;
        ["ARTIC_adminMessage", [_msg]] call CBA_fnc_globalEvent;
    };
} forEach [["lambs_danger", "LAMBS Danger"], ["VCOM_AI", "VCOM AI"]];
if (isClass (configFile >> "CfgPatches" >> "lambs_turrets")) then {
    ["LAMBS Turrets is loaded: compatible in principle; static-weapon crewing is checked by test D2.", "INFO"] call ARTIC_fnc_log;
};
