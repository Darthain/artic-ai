/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_lockPosture: [group]
    Stops DCO forcing combat mode YELLOW / speed FULL on this group, so ARTIC's posture holds.
*/
params ["_group"];
if (isNull _group) exitWith {};
_group setVariable ["SFSM_noAutoStance", true, true];
_group setVariable ["ARTIC_controlled", true, true];
