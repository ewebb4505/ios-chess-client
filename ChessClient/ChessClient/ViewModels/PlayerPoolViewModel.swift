//
//  PlayerPoolViewModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import Combine

class PlayerPoolViewModel {
    var player: Player? = nil
    let playerPoolManager: GameRequestWebSocketProtocol
    var cancel: AnyCancellable?
    
    init(player: Player? = nil,
         playerPoolManager: GameRequestWebSocketProtocol = GameRequestWebSocket(session: URLSession(configuration: .default, delegate: GameRequestWebSocketDelegate(), delegateQueue: .main), url: URL(string: "ws://127.0.0.1:8080/players_waiting_for_game")!)) {
        self.player = player
        self.playerPoolManager = playerPoolManager
    }
    
    func setupSubscribers() {
        cancel = playerPoolManager.passthrough.sink { error in
            print(error)
        } receiveValue: { message in
            print(message)
        }
    }
    
    func onLoad() {
        Task { @MainActor in
            do {
                // create user id
                let url = URL(string: "http://127.0.0.1:8080/user")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let (data, _) = try await URLSession.shared.data(for: request)
                if let newPlayer = try? JSONDecoder().decode(Player.self, from: data) {
                    player = newPlayer
                } else {
                    print("Invalid Response")
                    return
                }
                
                setupSubscribers()
                
                // connect to websocket
                playerPoolManager.socket.resume()
                
            } catch {
                print("Failed to Send POST Request \(error)")
            }
        }
    }
}
