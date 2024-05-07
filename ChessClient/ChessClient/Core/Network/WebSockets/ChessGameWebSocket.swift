//
//  ChessGameWebSocket.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import Combine

class ChessGameWebSocket: ChessGameWebSocketProtocol {
    var session: URLSession
    var url: URL
    var socket: URLSessionWebSocketTask
    var passthrough: PassthroughSubject<URLSessionWebSocketTask.Message, Error> = .init()
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
        self.socket = session.webSocketTask(with: url)
        
        socket.receive { result in
            switch result {
            case .success(let success):
                self.passthrough.send(success)
            case .failure(let failure):
                self.passthrough.send(completion: .failure(failure))
                return
            }
        }
    }
    
    func sendMove(){}
    func offerDraw(){}
    func recieveMove(){}
}
