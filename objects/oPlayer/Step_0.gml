/// @description Core Player Logic

// Get keyboard inputs
key_left = keyboard_check(vk_left);
key_right = keyboard_check(vk_right);
key_jump = keyboard_check_pressed(vk_space);

// Are we on a wall (within 5 pixels on either side)?
var onAWall = place_meeting(x+5, y, oWall) - place_meeting(x-5, y, oWall);

// Subtract 1 from mvtLocked every step (until we reach 0)
mvtLocked = max(mvtLocked -1, 0);

var _move = key_right - key_left;
hsp = _move * walksp;

// Jumping Mechanic (for wall jumps as well) 
// only works if mvtLocked has cooled down to 0
if (mvtLocked <= 0) {
	// If we on a wall, vertical speed will never
	// be greater than 5 
	if (onAWall != 0) vsp = min(vsp + 1, 5);
	else vsp = vsp + grv;
	
	if (key_jump) {
		// standard jump
		if ( place_meeting(x, y+1, oWall) && (key_jump)) {
			vsp = -jumpsp;
		}
		// wall jump
		if (onAWall != 0) {
			vsp = -jumpsp;
			hsp = onAWall * walksp;
			// set the cooldown (movement Locked) variable to 10
			mvtLocked = 10;
		}
	}
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

// Check to see if the player is idle or not (no vertical or horizontal speed
if (hsp == 0 && vsp == 0) {
	isIdle = true;
}
// Animation states
if (!place_meeting(x, y+1, oWall)) {
	sprite_index = sPlayerJump;
	image_speed = 0;
	
	// Are we moving up?
	if (vsp < -(jumpsp / 2)) {
		image_index = 1;
	}
	// Are we at the top of the jump?
	else if (vsp >= -(jumpsp / 2) && vsp <= (jumpsp / 2)) {
		image_index = 2;
	}
	// Are we falling?
	else if (vsp > (jumpsp / 2)) {
		image_index = 3;
	}
}
else {
	image_speed = 1;
	
	// are we idle or moving left or right
	if (hsp == 0) {
		sprite_index = sPlayerIdle;
	}
	else {
		sprite_index = sPlayerWalk;
	}
}

// Turn to face the direction we are moving horizontally
if (hsp != 0) image_xscale = sign(hsp);

