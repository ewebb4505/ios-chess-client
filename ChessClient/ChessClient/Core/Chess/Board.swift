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
    static func setBoard() -> Self {
        var board: Self = [:]
        board[.a8] = .R; board[.b8] = .N; board[.c8] = .B; board[.d8] = .Q; board[.e8] = .K; board[.f8] = .B; board[.g8] = .N; board[.h8] = .R
        board[.a7] = .P; board[.b7] = .P; board[.c7] = .P; board[.d7] = .P; board[.e7] = .P; board[.f7] = .P; board[.g7] = .P; board[.h7] = .P
        board[.a6] = nil; board[.b6] = nil; board[.c6] = nil; board[.d6] = nil; board[.e6] = nil; board[.f6] = nil; board[.g6] = nil; board[.h6] = nil
        board[.a5] = nil; board[.b5] = nil; board[.c5] = nil; board[.d5] = nil; board[.e5] = nil; board[.f5] = nil; board[.g5] = nil; board[.h5] = nil
        board[.a4] = nil; board[.b4] = nil; board[.c4] = nil; board[.d4] = nil; board[.e4] = nil; board[.f4] = nil; board[.g4] = nil; board[.h4] = nil
        board[.a3] = nil; board[.b3] = nil; board[.c3] = nil; board[.d3] = nil; board[.e3] = nil; board[.f3] = nil; board[.g3] = nil; board[.h3] = nil
        board[.a2] = .P; board[.b2] = .P; board[.c2] = .P; board[.d2] = .P; board[.e2] = .P; board[.f2] = .P; board[.g2] = .P; board[.h2] = .P
        board[.a1] = .R; board[.b1] = .N; board[.c1] = .B; board[.d1] = .Q; board[.e1] = .K; board[.f1] = .B; board[.g1] = .N; board[.h1] = .R
        return board
    }
    
    static func to2DArray() -> [[Spot]] {
        [[.a8,.b8,.c8,.d8,.e8,.f8,.g8,.h8],
         [.a7,.b7,.c7,.d7,.e7,.f7,.g7,.h7],
         [.a6,.b6,.c6,.d6,.e6,.f6,.g6,.h6],
         [.a5,.b5,.c5,.d5,.e5,.f5,.g5,.h5],
         [.a4,.b4,.c4,.d4,.e4,.f4,.g4,.h4],
         [.a3,.b3,.c3,.d3,.e3,.f3,.g3,.h3],
         [.a2,.b2,.c2,.d2,.e2,.f2,.g2,.h2],
         [.a1,.b1,.c1,.d1,.e1,.f1,.g1,.h1]]
            .reversed()
    }
}

extension Pieces {
    static func setPiecesForWhite() -> Self {
        var pieces: Self = [:]
        pieces[Piece.P] = [.a2,.b2,.c2,.d2,.e2,.f2,.g2,.h2]
        pieces[Piece.R] = [.a1,.h1]
        pieces[Piece.N] = [.b1,.g1]
        pieces[Piece.B] = [.c1,.f1]
        pieces[Piece.K] = [.e1]
        pieces[Piece.Q] = [.d1]
        return pieces
    }
    
    static func setPiecesForBlack() -> Self {
        var pieces: Self = [:]
        pieces[Piece.P] = [.a7,.b7,.c7,.d7,.e7,.f7,.g7,.h7]
        pieces[Piece.R] = [.a8,.h8]
        pieces[Piece.N] = [.b8,.g8]
        pieces[Piece.B] = [.c8,.f8]
        pieces[Piece.K] = [.e8]
        pieces[Piece.Q] = [.d8]
        return pieces
    }
}
