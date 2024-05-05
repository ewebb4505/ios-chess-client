//
//  Board.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation

typealias Board = [Spot : Piece?]
typealias Pieces = [Piece : [Spot]?]

extension Board {
    func setBoard() -> Self {
        //TODO: set rest of board
        var board: Self = [:]
        board[.a8] = .R; board[.b8] = .R; board[.c8] = .R; board[.d8] = .R; board[.e8] = .R; board[.f8] = .R; board[.g8] = .R; board[.h8] = .R
        board[.a7] = .P; board[.b7] = .P; board[.c7] = .P; board[.d7] = .P; board[.e7] = .P; board[.f7] = .P; board[.g7] = .P; board[.h7] = .P
        board[.a6] = nil; board[.b6] = nil; board[.c6] = nil; board[.d6] = nil; board[.e6] = nil; board[.f6] = nil; board[.g6] = nil; board[.h6] = nil
        board[.a5] = nil; board[.b5] = nil; board[.c5] = nil; board[.d5] = nil; board[.e5] = nil; board[.f5] = nil; board[.g5] = nil; board[.h5] = nil
        board[.a4] = nil; board[.b4] = nil; board[.c4] = nil; board[.d4] = nil; board[.e4] = nil; board[.f4] = nil; board[.g4] = nil; board[.h4] = nil
        board[.a3] = nil; board[.b3] = nil; board[.c3] = nil; board[.d3] = nil; board[.e3] = nil; board[.f3] = nil; board[.g3] = nil; board[.h3] = nil
        board[.a2] = .P; board[.b2] = .P; board[.c2] = .P; board[.d2] = .P; board[.e2] = .P; board[.f2] = .P; board[.g2] = .P; board[.h2] = .P
        board[.a1] = .R; board[.b1] = .R; board[.c1] = .R; board[.d1] = .R; board[.e1] = .R; board[.f1] = .R; board[.g1] = .R; board[.h1] = .R
        return board
    }
}
