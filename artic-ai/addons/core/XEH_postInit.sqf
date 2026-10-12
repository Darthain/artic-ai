/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC AI postInit.
*/
call ARTIC_fnc_eventBridge;
if (call ARTIC_fnc_hasDco) then { [{ call ARTIC_fnc_dcoGuard }, 10] call CBA_fnc_addPerFrameHandler; };
if (isServer) then {
    [{ call ARTIC_fnc_hcCheck; }, [], 20] call CBA_fnc_waitAndExecute;
    [{ call ARTIC_fnc_conflictCheck; }, [], 20] call CBA_fnc_waitAndExecute;
    ["ARTIC_test", { _this call ARTIC_fnc_testRun; }] call CBA_fnc_addEventHandler;
    ["ARTIC_battlePositionReady", { _this call ARTIC_fnc_testReport; }] call CBA_fnc_addEventHandler;
};

call ARTIC_fnc_testMenu;
