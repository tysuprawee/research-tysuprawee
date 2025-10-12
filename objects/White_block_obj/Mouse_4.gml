/// Click square logic
if (!variable_instance_exists(id,"pos")) exit;
if (!variable_instance_exists(id,"contain")) exit;

var clicked_pos   = pos;
var clicked_piece = contain; // "-" or "wp"/"br"/...

// If we already selected a piece, and this is a legal destination → MOVE
if (global.selected_pos != "" && array_length(global.current_moves) > 0) {
    if (array_contains_str(global.current_moves, clicked_pos)) {
        if (apply_move(global.selected_pos, clicked_pos)) {
            // optional: toggle turn
            // global.turn = (global.turn=="w") ? "b" : "w";
        }
        exit;
    }
}

// Otherwise: (re)select the piece on this square (if any) and show moves
if (clicked_piece != "-" && clicked_piece != "none") {
    global.select        = [clicked_piece, clicked_pos];
    global.selected_pos  = clicked_pos;
    global.current_moves = get_pseudo_legal_moves(clicked_pos);
    highlight_moves_from(clicked_pos, global.current_moves);
} else {
    // Empty square → just select/highlight that square
    global.select        = ["-", clicked_pos];
    global.selected_pos  = clicked_pos;
    global.current_moves = [];
    set_selected_visual(clicked_pos);
}

// Debug
show_debug_message("Clicked: " + clicked_piece + " @ " + clicked_pos);
