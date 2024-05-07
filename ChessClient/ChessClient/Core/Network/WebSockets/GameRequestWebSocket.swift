//
//  GameRequestWebSocket.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import Combine

class GameRequestWebSocket: GameRequestWebSocketProtocol {
    var passthrough: PassthroughSubject<URLSessionWebSocketTask.Message, Error> = .init()
    
    var session: URLSession
    var url: URL
    var socket: URLSessionWebSocketTask
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
        self.socket = session.webSocketTask(with: url)
    }
    
    func sendGameRequest() {}
    
    func leave() {}
    
    func pool() {}
}
