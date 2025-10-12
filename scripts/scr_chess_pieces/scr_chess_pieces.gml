/// ===== Piece instances: find/snap/move/capture =====

function find_piece_at_pos(_pos) {
    var found = noone;
    with (white_pawn_obj) {
        if (pos == _pos) { found = id; exit; }
    }
    return found;
}

// snap a piece instance to algebraic square (sets instance x,y and pos)
function snap_piece_to_pos(_inst, _pos) {
    var xy = pos_to_xy(_pos);
    with (_inst) {
        x = xy[0];
        y = xy[1];
        pos = _pos;
    }
}

// move + capture + board update + tiles refresh
function apply_move(_from_pos, _to_pos) {
    var mover = find_piece_at_pos(_from_pos);
    if (mover == noone) return false;

    // capture if any
    var victim = find_piece_at_pos(_to_pos);
    if (victim != noone) with (victim) instance_destroy();

    // update board
    var piece_code = at_pos(_from_pos);
    set_pos(_to_pos, piece_code);
    set_pos(_from_pos, EMPTY);

    // move piece instance
    snap_piece_to_pos(mover, _to_pos);

    // sync tiles to new board state
    refresh_tiles_from_board();

    // clear selection
    clear_selection_visuals();
    global.selected_pos  = "";
    global.current_moves = [];

    return true;
}

function array_contains_str(_arr, _s) {
    for (var i=0;i<array_length(_arr);i++) if (_arr[i]==_s) return true;
    return false;
}
