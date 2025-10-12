/// --- Game setup ---
global.turn          = "w";
global.select        = ["none","none"]; // [piece_code, pos]
global.selected_pos  = "";
global.current_moves = [];

intialize_board(false);
debug_print_board();

// Ensure tiles already in room have correct 'contain'
refresh_tiles_from_board();
