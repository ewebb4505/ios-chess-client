//
//  ChessBoardSpotModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/8/24.
//

import Foundation

class ChessBoardSpotModel: Hashable, Identifiable {
    var id: Spot { self.square }
    var square: Spot
    var piece: Piece?
    var isWhiteSquare: Bool = true
    var shouldAddHighlight: Bool = false
    
    init(square: Spot) {
        self.square = square
    }
    
    static func == (lhs: ChessBoardSpotModel, rhs: ChessBoardSpotModel) -> Bool {
        lhs.id == rhs.id && lhs.piece == rhs.piece
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(piece)
    }
}
