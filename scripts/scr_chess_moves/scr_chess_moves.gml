/// ===== Pseudo-legal move generation =====

function is_empty_rc(_r,_c) { return at_rc(_r,_c) == EMPTY; }
function is_enemy_rc(_r,_c,_myc) {
    var pc = color_of_piece(at_rc(_r,_c));
    return (pc != "-") && (pc != _myc);
}

// sliding
function ray_moves(_r,_c,_dr,_dc,_myc,_out) {
    var rr=_r+_dr, cc=_c+_dc;
    while (in_bounds(rr,cc)) {
        if (is_empty_rc(rr,cc)) {
            _out[array_length(_out)] = rc_to_pos(rr,cc);
        } else {
            if (is_enemy_rc(rr,cc,_myc)) _out[array_length(_out)] = rc_to_pos(rr,cc);
            break;
        }
        rr+=_dr; cc+=_dc;
    }
}
function rook_moves(_r,_c,_myc,_out) {
    ray_moves(_r,_c,-1,0,_myc,_out);
    ray_moves(_r,_c, 1,0,_myc,_out);
    ray_moves(_r,_c, 0,-1,_myc,_out);
    ray_moves(_r,_c, 0, 1,_myc,_out);
}
function bishop_moves(_r,_c,_myc,_out) {
    ray_moves(_r,_c,-1,-1,_myc,_out);
    ray_moves(_r,_c,-1, 1,_myc,_out);
    ray_moves(_r,_c, 1,-1,_myc,_out);
    ray_moves(_r,_c, 1, 1,_myc,_out);
}

// leapers
function knight_moves(_r,_c,_myc,_out) {
    var D=[[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]];
    for (var i=0;i<array_length(D);i++) {
        var rr=_r+D[i][0], cc=_c+D[i][1];
        if (in_bounds(rr,cc) && (is_empty_rc(rr,cc) || is_enemy_rc(rr,cc,_myc))) {
            _out[array_length(_out)] = rc_to_pos(rr,cc);
        }
    }
}
function king_moves(_r,_c,_myc,_out) {
    for (var dr=-1; dr<=1; dr++) for (var dc=-1; dc<=1; dc++) {
        if (dr==0 && dc==0) continue;
        var rr=_r+dr, cc=_c+dc;
        if (in_bounds(rr,cc) && (is_empty_rc(rr,cc) || is_enemy_rc(rr,cc,_myc))) {
            _out[array_length(_out)] = rc_to_pos(rr,cc);
        }
    }
}

// pawns
function pawn_moves(_r,_c,_myc,_out) {
    var dir       = (_myc=="w") ? -1 : 1;
    var start_row = (_myc=="w") ? 6 : 1;

    var f1r=_r+dir, f1c=_c;
    if (in_bounds(f1r,f1c) && is_empty_rc(f1r,f1c)) {
        _out[array_length(_out)] = rc_to_pos(f1r,f1c);
        var f2r=_r+2*dir;
        if (_r==start_row && is_empty_rc(f2r,f1c)) {
            _out[array_length(_out)] = rc_to_pos(f2r,f1c);
        }
    }

    var capLr=_r+dir, capLc=_c-1;
    var capRr=_r+dir, capRc=_c+1;
    if (in_bounds(capLr,capLc) && is_enemy_rc(capLr,capLc,_myc))
        _out[array_length(_out)] = rc_to_pos(capLr,capLc);
    if (in_bounds(capRr,capRc) && is_enemy_rc(capRr,capRc,_myc))
        _out[array_length(_out)] = rc_to_pos(capRr,capRc);
}

// entry
function get_pseudo_legal_moves(_pos) {
    var rc = pos_to_rc(_pos);
    var r=rc[0], c=rc[1];
    if (!in_bounds(r,c)) return [];

    var piece = at_rc(r,c);
    if (piece == EMPTY) return [];

    var myc = color_of_piece(piece);
    var t   = piece_type(piece);

    var out = [];
    switch (t) {
        case "p": pawn_moves(r,c,myc,out); break;
        case "r": rook_moves(r,c,myc,out); break;
        case "n": knight_moves(r,c,myc,out); break;
        case "b": bishop_moves(r,c,myc,out); break;
        case "q": rook_moves(r,c,myc,out); bishop_moves(r,c,myc,out); break;
        case "k": king_moves(r,c,myc,out); break;
    }
    return out;
}
