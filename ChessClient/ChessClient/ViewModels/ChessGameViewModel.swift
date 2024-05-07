//
//  ChessGameViewModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import Combine

class ChessGameViewModel {
    let whitePlayer: Player
    let blackPlayer: Player
    
    let session: ChessGameWebSocketProtocol
    
    //I need to observe changes from the view contoller on this board so I can update the UI
    let data: Board = Board.setBoard()
    var anyCancellable: Set<AnyCancellable> = .init()
    
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
}
