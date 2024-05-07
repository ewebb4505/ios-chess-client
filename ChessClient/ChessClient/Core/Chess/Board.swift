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
        board[.a8] = .BR; board[.b8] = .BN; board[.c8] = .BB; board[.d8] = .BQ; board[.e8] = .BK; board[.f8] = .BB; board[.g8] = .BN; board[.h8] = .BR
        board[.a7] = .BP; board[.b7] = .BP; board[.c7] = .BP; board[.d7] = .BP; board[.e7] = .BP; board[.f7] = .BP; board[.g7] = .BP; board[.h7] = .BP
        board[.a6] = nil; board[.b6] = nil; board[.c6] = nil; board[.d6] = nil; board[.e6] = nil; board[.f6] = nil; board[.g6] = nil; board[.h6] = nil
        board[.a5] = nil; board[.b5] = nil; board[.c5] = nil; board[.d5] = nil; board[.e5] = nil; board[.f5] = nil; board[.g5] = nil; board[.h5] = nil
        board[.a4] = nil; board[.b4] = nil; board[.c4] = nil; board[.d4] = nil; board[.e4] = nil; board[.f4] = nil; board[.g4] = nil; board[.h4] = nil
        board[.a3] = nil; board[.b3] = nil; board[.c3] = nil; board[.d3] = nil; board[.e3] = nil; board[.f3] = nil; board[.g3] = nil; board[.h3] = nil
        board[.a2] = .WP; board[.b2] = .WP; board[.c2] = .WP; board[.d2] = .WP; board[.e2] = .WP; board[.f2] = .WP; board[.g2] = .WP; board[.h2] = .WP
        board[.a1] = .WR; board[.b1] = .WN; board[.c1] = .WB; board[.d1] = .WQ; board[.e1] = .WK; board[.f1] = .WB; board[.g1] = .WN; board[.h1] = .WR
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
    
    func pieceAt(row: Int, fileIndex: Int) -> Piece? {
        let file = Spot.files[fileIndex]
        let spot = Spot.construct(row: row+1, file: file)!
        let piece = self[spot] ?? nil
        return piece
    }
    
    func spotAt(row: Int, fileIndex: Int) -> Spot {
        let file = Spot.files[fileIndex]
        let spot = Spot.construct(row: row+1, file: file)!
        return spot
    }
}

extension Pieces {
    static func setPiecesForWhite() -> Self {
        var pieces: Self = [:]
        pieces[Piece.WP] = [.a2,.b2,.c2,.d2,.e2,.f2,.g2,.h2]
        pieces[Piece.WR] = [.a1,.h1]
        pieces[Piece.WN] = [.b1,.g1]
        pieces[Piece.WB] = [.c1,.f1]
        pieces[Piece.WK] = [.e1]
        pieces[Piece.WQ] = [.d1]
        return pieces
    }
    
    static func setPiecesForBlack() -> Self {
        var pieces: Self = [:]
        pieces[Piece.BP] = [.a7,.b7,.c7,.d7,.e7,.f7,.g7,.h7]
        pieces[Piece.BR] = [.a8,.h8]
        pieces[Piece.BN] = [.b8,.g8]
        pieces[Piece.BB] = [.c8,.f8]
        pieces[Piece.BK] = [.e8]
        pieces[Piece.BQ] = [.d8]
        return pieces
    }
}
