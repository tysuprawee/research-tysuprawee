/// Parent for all pieces
// Children should set: color ("w" or "b") and optionally pos ("e2")

if (!variable_instance_exists(id, "pos") || !is_valid_pos(pos)) {
    // If invalid/missing, infer from where the instance is placed in the room:
    pos = xy_to_pos(x, y);
}
