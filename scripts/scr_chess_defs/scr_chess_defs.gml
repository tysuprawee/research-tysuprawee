/// ===== Chess core: macros, board, algebra, sync =====

// --- Abbreviations
#macro EMPTY   "-"
#macro WR      "wr"
#macro WK      "wk"
#macro WB      "wb"
#macro WQ      "wq"
#macro WKING   "wking"
#macro WP      "wp"
#macro BR      "br"
#macro BK      "bk"
#macro BB      "bb"
#macro BQ      "bq"
#macro BKING   "bking"
#macro BP      "bp"

// --- Globals
globalvar board, GRID_ORIGIN_X, GRID_ORIGIN_Y, CELL_SIZE;
GRID_ORIGIN_X = 0;      // set these for your room
GRID_ORIGIN_Y = 0;
CELL_SIZE     = 64;

// Create an 8×8 array filled with "-"
function _create_empty_board() {
    var b = array_create(8);
    for (var r = 0; r < 8; r++) b[r] = array_create(8, EMPTY);
    return b;
}

// Standard setup
function intialize_board(reverse_side = false) {
    board = _create_empty_board();

    var white_back  = [WR, WK, WB, WQ, WKING, WB, WK, WR];
    var black_back  = [BR, BK, BB, BQ, BKING, BB, BK, BR];
    var white_pawns = [WP, WP, WP, WP, WP, WP, WP, WP];
    var black_pawns = [BP, BP, BP, BP, BP, BP, BP, BP];

    if (!reverse_side) {
        board[0] = black_back;
        board[1] = black_pawns;
        board[6] = white_pawns;
        board[7] = white_back;
    } else {
        board[0] = white_back;
        board[1] = white_pawns;
        board[6] = black_pawns;
        board[7] = black_back;
    }
    return board;
}


/// Returns true if _pos is like "a1".."h8"
function is_valid_pos(_pos) {
    if (!is_string(_pos)) return false;
    if (string_length(_pos) != 2) return false;

    var f = string_lower(string_char_at(_pos, 1));
    var r = string_char_at(_pos, 2);

    if (ord(f) < ord("a") || ord(f) > ord("h")) return false;
    if (ord(r) < ord("1") || ord(r) > ord("8")) return false;

    return true;
}

// Debug-print board
function debug_print_board() {
    show_debug_message("---- CHESS BOARD ----");
    for (var r = 0; r < 8; r++) {
        var row = board[r];
        var s = row[0];
        for (var i = 1; i < 8; i++) s += "," + string(row[i]);
        show_debug_message(s);
    }
}

// ---------- Algebraic <-> indices / coords ----------
function pos_to_rc(_pos) {
    // Harden against bad inputs
    if (!is_valid_pos(_pos)) {
        show_debug_message("WARN pos_to_rc: invalid pos = " + string(_pos) + " (defaulting to a1)");
        return [7, 0]; // a1
    }

    var file = ord(string_lower(string_char_at(_pos, 1))) - ord("a"); // 0..7
    var rank = real(string_char_at(_pos, 2));                         // 1..8
    var r = 8 - rank;
    var c = file;
    return [r, c];
}

function rc_to_pos(_r, _c) {
    var file = chr(_c + ord("a"));
    var rank = string(8 - _r);
    return file + rank;
}
function pos_to_xy(_pos) {
    var rc = pos_to_rc(_pos); var r = rc[0], c = rc[1];
    var px = GRID_ORIGIN_X + c * CELL_SIZE + CELL_SIZE * 0.5;
    var py = GRID_ORIGIN_Y + r * CELL_SIZE + CELL_SIZE * 0.5;
    return [px, py];
}
function xy_to_pos(_x, _y) {
    var c = floor((_x - GRID_ORIGIN_X)/CELL_SIZE);
    var r = floor((_y - GRID_ORIGIN_Y)/CELL_SIZE);
    c = clamp(c,0,7); r = clamp(r,0,7);
    return rc_to_pos(r,c);
}

function in_bounds(_r, _c) { return (_r>=0)&&(_r<8)&&(_c>=0)&&(_c<8); }

// --- board accessors
function at_rc(_r,_c) { return board[_r][_c]; }
function set_rc(_r,_c,_piece) { board[_r][_c] = _piece; }
function at_pos(_pos) {
    var rc = pos_to_rc(_pos);
    return board[rc[0]][rc[1]];
}
function set_pos(_pos,_piece) {
    var rc = pos_to_rc(_pos);
    board[rc[0]][rc[1]] = _piece;
}

// --- piece info
function color_of_piece(_piece) {
    if (_piece == EMPTY) return "-";
    var ch = string_char_at(_piece,1);
    return (ch=="w") ? "w" : (ch=="b" ? "b" : "-");
}
function piece_type(_piece) {
    switch (_piece) {
        case WP:
        case BP:
            return "p";
        case WR:
        case BR:
            return "r";
        case WK:
        case BK:
            return "n";
        case WB:
        case BB:
            return "b";
        case WQ:
        case BQ:
            return "q";
        case WKING:
        case BKING:
            return "k";
    }
    return "";
}

// --- sync tiles from board (writes each tile's `contain`)
function refresh_tiles_from_board() {
    with (White_block_obj) contain = at_pos(pos);
    with (Black_block_obj) contain = at_pos(pos);
}
