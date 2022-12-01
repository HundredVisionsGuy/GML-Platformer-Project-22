/// @description Core Player Logic

// Get keyboard inputs
key_left = keyboard_check(vk_left);
key_right = keyboard_check(vk_right);
key_jump = keyboard_check_pressed(vk_space);

var _move = key_right - key_left;
hsp = _move * walksp;
vsp = vsp + grv;

// Jumping Mechanic
if ( place_meeting(x, y+1, oWall) && (key_jump)) {
	vsp = -jumpsp;
}

// Horizontal Collision Check
if ( place_meeting(x + hsp, y, oWall) ) {
	// Move towards object until just before a collision
	while ( !place_meeting(x + sign(hsp), y, oWall) ) {
		x = x + sign(hsp);
	}
	hsp = 0;
}
x = x + hsp;

// Vertical Collision Check
if ( place_meeting(x, y + vsp, oWall) ) {
	// Move towards object until just before a collision
	while ( !place_meeting(x, y + sign(vsp), oWall) ) {
		y = y + sign(vsp);
	}
	vsp = 0;
}
y = y + vsp;