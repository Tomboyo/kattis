use std::io::{self, Read, StdinLock, Bytes};

type Board = [[u8; 11]; 11];

fn main() {
    // Allocate a blank board with 2 columns and 2 rows of padding on either side (sentinel values)
    let mut board: Board = [
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' '],
        [b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ', b' ']
    ];

    // Ingest the 7 rows of board data
    let input = io::stdin();
    let mut bytes = input.lock().bytes();
    for row in 0..7 {
        load_row(&mut board, &mut bytes, 2 + row);
    }

    // iterate the 7x7 populated elements within the board
    let mut legal_moves = 0;
    for x in 2..9 {
        for y in 2..9 {
            if b'.' != board[x][y] { continue; }

            // Check all cardinal directions for two pieces in a row, which imply a legal move
            // up
            if b'o' == board[x][y - 1] && b'o' == board[x][y - 2] { legal_moves += 1; }
            // right
            if b'o' == board[x + 1][y] && b'o' == board[x + 2][y] { legal_moves += 1; }
            // down
            if b'o' == board[x][y + 1] && b'o' == board[x][y + 2] { legal_moves += 1; }
            // left
            if b'o' == board[x - 1][y] && b'o' == board[x - 2][y] { legal_moves += 1; }
        }
    }

    // print number of moves
    println!("{}", legal_moves);
}

fn load_row(board: &mut Board, bytes: &mut Bytes<StdinLock>, row: usize) {
    bytes.take(7).enumerate().for_each(|(i, x)| board[row][2 + i] = x.unwrap());
    bytes.next(); // consume newline
}
