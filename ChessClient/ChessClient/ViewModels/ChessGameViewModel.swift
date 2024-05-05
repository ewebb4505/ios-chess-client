//
//  ChessGameViewModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation

class ChessGameViewModel {
    let whitePlayer: Player
    let blackPlayer: Player
    
    let session: ChessGameWebSocketProtocol
    
    let data: Board = Board.setBoard()
    
    init(whitePlayer: Player,
         blackPlayer: Player,
         session: ChessGameWebSocketProtocol = ChessGameWebSocket(session: URLSession(configuration: .default, delegate: ChessGameWebSocketDelegate(), delegateQueue: .main), url: URL(string: "wss://127.0.0.1:8080/")!)) {
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
        self.session = session
    }
}
