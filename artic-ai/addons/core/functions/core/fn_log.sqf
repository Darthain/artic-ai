/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_log: [message, level] - RPT log, plus chat when ARTIC debug is on.
    level: "INFO" | "WARN" | "ERROR"
*/
params [["_msg", ""], ["_level", "INFO"]];
diag_log format ["[ARTIC AI][%1] %2", _level, _msg];
if (missionNamespace getVariable ["ARTIC_debug", false] && {hasInterface}) then {
    systemChat format ["ARTIC: %1", _msg];
};
