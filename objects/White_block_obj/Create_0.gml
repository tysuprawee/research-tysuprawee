tile_color  = "white";             // avoid using reserved name "color" for safety
sprite_index = White_block;

if (!variable_instance_exists(id,"pos") || pos == "") pos = xy_to_pos(x,y);
contain = "-"; // controller will refresh true value
