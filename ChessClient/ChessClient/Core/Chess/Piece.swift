//
//  Piece.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

enum Piece: String, CaseIterable {
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
}
