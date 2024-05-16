//
//  ChessGameViewModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import Combine

class ChessGameViewModel {
    struct TapTracker {
        var firstTap: (spot: Spot, piece: Piece)? = nil
        var secondTap: (spot: Spot, piece: Piece?)? = nil
    }
    
    let whitePlayer: Player
    let blackPlayer: Player
    let session: ChessGameWebSocketProtocol
    
    //I need to observe changes from the view contoller on this board so I can update the UI
    var data: Board = Board.setBoard()
    var anyCancellable: Set<AnyCancellable> = .init()
    var playersTurn: PlayerColor = .white
    var tapTracker = TapTracker()
    var highlightedSpots: Set<ChessBoardSpotModel> = []
    
    init(whitePlayer: Player,
         blackPlayer: Player,
         session: ChessGameWebSocketProtocol = ChessGameWebSocket(session: URLSession(configuration: .default, delegate: ChessGameWebSocketDelegate(), delegateQueue: .main), url: URL(string: "ws://127.0.0.1:8080/players_waiting_for_game")!)) {
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
        self.session = session
    }
    
    func updateBoard() {
        session.passthrough.sink { error in
            print(error)
        } receiveValue: { message in
            print(message)
        }.store(in: &anyCancellable)
    }
    
    func handleTap(spot: Spot, piece: Piece?) {
        if tapTracker.firstTap == nil, let piece {
            tapTracker.firstTap = (spot: spot, piece: piece)
        } else if tapTracker.secondTap == nil && tapTracker.firstTap?.piece == piece {
            // reset the tap tracker
            tapTracker.firstTap = nil
            tapTracker.secondTap = nil
        } else if tapTracker.secondTap == nil {
            tapTracker.secondTap = (spot: spot, piece: piece)
        } else {
            fatalError("Both firstTap and secondTap can't be nil while handling a tap")
        }
    }
}

enum PlayerColor {
    case white
    case black
}
