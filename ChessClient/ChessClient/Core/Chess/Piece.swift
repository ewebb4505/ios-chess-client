//
//  Piece.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

enum Piece: String, CaseIterable {
    case P, K, N, Q, B, R
}

extension Piece {
    func getImage(isWhite: Bool = true) -> UIImage? {
        switch self {
        case .P:
            isWhite ? UIImage(named: "black_pawn") : UIImage(named: "white_pawn")
        case .K:
            isWhite ? UIImage(named: "black_king") : UIImage(named: "white_king")
        case .N:
            isWhite ? UIImage(named: "black_knight") : UIImage(named: "white_knight")
        case .Q:
            isWhite ? UIImage(named: "black_queen") : UIImage(named: "white_queen")
        case .B:
            isWhite ? UIImage(named: "black_bishop") : UIImage(named: "white_bishop")
        case .R:
            isWhite ? UIImage(named: "black_rook") : UIImage(named: "white_rook")
        }
    }
}
