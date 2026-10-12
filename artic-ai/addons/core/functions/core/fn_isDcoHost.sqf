/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_isDcoHost: true on the machine where DCO Soldier FSM runs its battle loop.
    Mirrors DCO's own rule: if a headless client is connected and named for DCO (PR_HC1,
    default unit name "HC"), DCO runs there and the server skips it; otherwise the server.
*/
private _hcMode = (count (missionNamespace getVariable ["PR_HeadlessClients", []]) > 0)
    && {!isNil {missionNamespace getVariable "PR_HC1"}};
if (_hcMode) then { !hasInterface && {!isServer} } else { isServer }
