//
//  PlayerPoolViewModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation

class PlayerPoolViewModel {
    let player: Player
    let playerPoolManager: any GameRequestWebSocketProtocol
    
    init(player: Player, playerPoolManager: any GameRequestWebSocketProtocol = PlayerPoolManager(session: URLSession(configuration: .default, delegate: GameRequestWebSocket(), delegateQueue: .main), url: URL(string: "something")!)) {
        self.player = player
        self.playerPoolManager = playerPoolManager
    }
}
