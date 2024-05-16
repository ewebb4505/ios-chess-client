//
//  Piece.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

enum Piece: String, CaseIterable, Hashable {
    case WP, BP, WK, BK, WN, BN, WQ, BQ, WB, BB, WR, BR
    
    var image: UIImage? {
        switch self {
        case .WP:
            UIImage(named: "white_pawn")
        case .BP:
            UIImage(named: "black_pawn")
        case .WK:
            UIImage(named: "white_king")
        case .BK:
            UIImage(named: "black_king")
        case .WN:
            UIImage(named: "white_knight")
        case .BN:
            UIImage(named: "black_knight")
        case .WQ:
            UIImage(named: "white_queen")
        case .BQ:
            UIImage(named: "black_queen")
        case .WB:
            UIImage(named: "white_bishop")
        case .BB:
            UIImage(named: "black_bishop")
        case .WR:
            UIImage(named: "white_rook")
        case .BR:
            UIImage(named: "black_rook")
        }
    }
    
    var isWhite: Bool {
        self == .WP || self == .WK || self == .WN || self == .WQ || self == .WB || self == .WR
    }
}

extension Piece {
    func reaches(from spot: Spot,
                 on board: Board) -> Set<Spot>? {
        var spots: Set<Spot>? = nil
        switch self {
        case .WP:
            // TODO: if there's a piece in front of the pawn then it can't move.
            // if spot is along row 2 then it can move forward two squares)
            var twoSpotsAheadOfWhitePawn: Spot?
            if spot.row == 2 {
                twoSpotsAheadOfWhitePawn = spot.move(up: 2)
            }
            
            let spotAheadOfWhitePawn = spot.move(up: 1)
            let spotAttackedToRightOfWhitePawn = spot.move(up: 1, right: 1)
            let spotAttackedToLeftOfWhitePawn = spot.move(up: 1, left: 1)
            
            if let spotAheadOfWhitePawn {
                spots = .init()
                if board[spotAheadOfWhitePawn] == nil as Piece? {
                    spots?.insert(spotAheadOfWhitePawn)
                }
                
                if let spotAttackedToRightOfWhitePawn,
                    let rightAttackedPiece = board[spotAttackedToRightOfWhitePawn],
                   (rightAttackedPiece == .BP || rightAttackedPiece == .BB || rightAttackedPiece == .BK || rightAttackedPiece == .BN || rightAttackedPiece == .BQ || rightAttackedPiece == .BR) {
                    spots?.insert(spotAttackedToRightOfWhitePawn)
                }
                
                if let spotAttackedToLeftOfWhitePawn, let leftAttackedPiece = board[spotAttackedToLeftOfWhitePawn],
                   (leftAttackedPiece == .BP || leftAttackedPiece == .BB || leftAttackedPiece == .BK || leftAttackedPiece == .BN || leftAttackedPiece == .BQ || leftAttackedPiece == .BR) {
                    spots?.insert(spotAttackedToLeftOfWhitePawn)
                }
                
                if let twoSpotsAheadOfWhitePawn, board[twoSpotsAheadOfWhitePawn] == nil as Piece? {
                    spots?.insert(twoSpotsAheadOfWhitePawn)
                }
            } else {
                // if there's no spot ahead of the pawn this means this pawn can be promoted
                return spots
            }
        case .BP:
            // TODO: if there's a piece in front of the pawn then it can't move. 
            // if spot is along row 2 then it can move forward two squares)
            var twoSpotsAheadOfBlackPawn: Spot?
            if spot.row == 7 {
                twoSpotsAheadOfBlackPawn = spot.move(down: 2)
            }
            
            let spotAheadOfBlackPawn = spot.move(down: 1)
            let spotAttackedToRightOfBlackPawn = spot.move(down: 1, right: 1)
            let spotAttackedToLeftOfBlackPawn = spot.move(down: 1, left: 1)
            
            if let spotAheadOfBlackPawn {
                spots = .init()
                if board[spotAheadOfBlackPawn] == nil as Piece? {
                    spots?.insert(spotAheadOfBlackPawn)
                }
                
                if let spotAttackedToRightOfBlackPawn,
                    let rightAttackedPiece = board[spotAttackedToRightOfBlackPawn],
                   (rightAttackedPiece == .WP || rightAttackedPiece == .WB || rightAttackedPiece == .WK || rightAttackedPiece == .WN || rightAttackedPiece == .WQ || rightAttackedPiece == .WR) {
                    spots?.insert(spotAttackedToRightOfBlackPawn)
                }
                
                if let spotAttackedToLeftOfBlackPawn, let leftAttackedPiece = board[spotAttackedToLeftOfBlackPawn],
                   (leftAttackedPiece == .WP || leftAttackedPiece == .WB || leftAttackedPiece == .WK || leftAttackedPiece == .WN || leftAttackedPiece == .WQ || leftAttackedPiece == .WR) {
                    spots?.insert(spotAttackedToLeftOfBlackPawn)
                }
                
                if let twoSpotsAheadOfBlackPawn, board[twoSpotsAheadOfBlackPawn] == nil as Piece? {
                    spots?.insert(twoSpotsAheadOfBlackPawn)
                }
            } else {
                // if there's no spot ahead of the pawn this means this pawn can be promoted
                return spots
            }
        case .WK:
            return .init()
        case .BK:
            return .init()
        case .WN:
            var x: Set<Spot?> = []
            x.insert(spot.move(up: 2, right: 1))
            x.insert(spot.move(up: 2, left: 1))
            x.insert(spot.move(up: 1, right: 2))
            x.insert(spot.move(up: 1, left: 2))
            x.insert(spot.move(down: 2, right: 1))
            x.insert(spot.move(down: 2, left: 1))
            x.insert(spot.move(down: 1, left: 2))
            x.insert(spot.move(down: 1, right: 2))
            spots = Set(x.compactMap({ $0 }).filter({ !(board[$0]??.isWhite ?? false) }))
            return spots
        case .BN:
            var x: Set<Spot?> = []
            x.insert(spot.move(up: 2, right: 1))
            x.insert(spot.move(up: 2, left: 1))
            x.insert(spot.move(up: 1, right: 2))
            x.insert(spot.move(up: 1, left: 2))
            x.insert(spot.move(down: 2, right: 1))
            x.insert(spot.move(down: 2, left: 1))
            x.insert(spot.move(down: 1, left: 2))
            x.insert(spot.move(down: 1, right: 2))
            spots = Set(x.compactMap({ $0 }).filter({ board[$0]??.isWhite ?? true }))
            return spots
        case .WQ:
            return .init()
        case .BQ:
            return .init()
        case .WB:
            return .init()
        case .BB:
            return .init()
        case .WR:
            return .init()
        case .BR:
            return .init()
        }
        return spots
    }
    //    fun Pieces.squaresAttackedBy(piece: Piece, at: BoardSpot, isWhitePiece: Boolean = true): Set<BoardSpot> {
    //        when(piece) {
    //            Piece.Q -> {
    //                val attackedSpots = BoardSpot.entries.toMutableList()
    //                attackedSpots.remove(at)
    //                return attackedSpots.toSet()
    //            }
    //
    //            Piece.K -> {
    //                return at.getAdjacent()
    //            }
    //
    //            Piece.R -> {
    //                val row = at.row()
    //                val file = at.file()
    //
    //                // todo: change this to map over BoardSpot.files
    //                val spotsOnRow = mutableSetOf (
    //                    BoardSpot.construct(row, "a"),
    //                    BoardSpot.construct(row, "b"),
    //                    BoardSpot.construct(row, "c"),
    //                    BoardSpot.construct(row, "d"),
    //                    BoardSpot.construct(row, "e"),
    //                    BoardSpot.construct(row, "f"),
    //                    BoardSpot.construct(row, "g"),
    //                    BoardSpot.construct(row, "h")
    //                ).filterNotNull().toMutableSet()
    //
    //                // todo: change this to loop
    //                val spotsOnFile = mutableSetOf (
    //                    BoardSpot.construct(1, file),
    //                    BoardSpot.construct(2, file),
    //                    BoardSpot.construct(3, file),
    //                    BoardSpot.construct(4, file),
    //                    BoardSpot.construct(5, file),
    //                    BoardSpot.construct(6, file),
    //                    BoardSpot.construct(7, file),
    //                    BoardSpot.construct(8, file),
    //                ).filterNotNull().toMutableSet()
    //
    //                spotsOnRow.remove(at)
    //                spotsOnFile.remove(at)
    //                return (spotsOnFile + spotsOnRow).toSet()
    //            }
    //
    //            Piece.B -> {
    //                val attackingSpots: MutableSet<BoardSpot> = mutableSetOf()
    //
    //                for (i in 1..8) {
    //                    at.next(up = i, left = i)?.let { attackingSpots.add(it) }
    //                    at.next(up = i, right = i)?.let { attackingSpots.add(it) }
    //                    at.next(down = i, left = i)?.let { attackingSpots.add(it) }
    //                    at.next(down = i, right = i)?.let { attackingSpots.add(it) }
    //                }
    //
    //                return attackingSpots
    //            }
    //
    //            Piece.N -> {
    //                return setOfNotNull(
    //                    at.next(up = 2, right = 1),
    //                    at.next(up = 2, left = 1),
    //                    at.next(up = 1, right = 2),
    //                    at.next(up = 1, left = 2),
    //                    at.next(down = 2, right = 1),
    //                    at.next(down = 2, left = 1),
    //                    at.next(down = 1, right = 2),
    //                    at.next(down = 1, left = 2),
    //                )
    //            }
    //            Piece.P -> {
    //                return if (isWhitePiece) {
    //                    setOfNotNull(
    //                        at.next(up = 1, right = 1),
    //                        at.next(up = 1, left = 1),
    //                    )
    //                } else {
    //                    setOfNotNull(
    //                        at.next(down = 1, right = 1),
    //                        at.next(down = 1, left = 1),
    //                    )
    //                }
    //            }
    //        }
    //    }
}
