/// ===== Visual helpers =====

// Reset tiles to base
function clear_selection_visuals() {
    with (White_block_obj) sprite_index = White_block;
    with (Black_block_obj) sprite_index = Black_block;
}

// Highlight one square
function set_selected_visual(_pos) {
    clear_selection_visuals();
    with (White_block_obj) if (pos == _pos) sprite_index = White_block_hovered;
    with (Black_block_obj) if (pos == _pos) sprite_index = Black_block_hovered;
}

// Highlight origin + a list of moves
function highlight_moves_from(_from_pos, _moves_array) {
    clear_selection_visuals();

    with (White_block_obj) if (pos == _from_pos) sprite_index = White_block_hovered;
    with (Black_block_obj) if (pos == _from_pos) sprite_index = Black_block_hovered;

    for (var i=0;i<array_length(_moves_array);i++) {
        var to = _moves_array[i];
        with (White_block_obj) if (pos == to) sprite_index = White_block_hovered;
        with (Black_block_obj) if (pos == to) sprite_index = Black_block_hovered;
    }
}
