/*
 * ARTIC AI
 * Copyright (C) 2026 ARTIC AI contributors
 * SPDX-License-Identifier: GPL-2.0-only
 * Licensed under the GNU General Public License v2.0 only. See LICENSE and CREDITS.md.
 */
/*
    ARTIC_fnc_earthworkClear: [position, radius] -> true if no ARTIC earthwork (trench, sandbags,
    net) is within radius. Used to stop trench pieces stacking at junctions and overlaps.
*/
params ["_pos", ["_radius", 2]];
((nearestObjects [_pos, [], _radius]) findIf { _x getVariable ["ARTIC_engineeringObject", false] }) < 0
