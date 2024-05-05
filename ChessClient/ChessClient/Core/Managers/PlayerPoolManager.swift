//
//  PlayerPoolManager.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation

class PlayerPoolManager: GameRequestWebSocketProtocol {
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
    
//    static let session = URLSession(configuration: .default,
//                                    delegate: GameRequestWebSocket(),
//                                    delegateQueue: OperationQueue())
//    static let url = URL(string: "wss://echo.websocket.org")!
//    static let webSocketTask = session.webSocketTask(with: url)
        
}

class GameRequestWebSocket: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket did close")
    }
}

protocol GameRequestWebSocketProtocol {
    var session: URLSession { get }
    var url: URL { get }
    var socket: URLSessionWebSocketTask { get }
    
    func sendGameRequest()
    func leave()
    func pool()
}

protocol ChessGameWebSocketProtocol {
    var session: URLSession { get }
    var url: URL { get }
    var socket: URLSessionWebSocketTask { get }
    
    func sendMove()
    func offerDraw()
    func recieveMove()
}

class ChessGameWebSocketDelegate: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket did close")
    }
}

class ChessGameWebSocket: ChessGameWebSocketProtocol {
    var session: URLSession
    var url: URL
    var socket: URLSessionWebSocketTask
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
        self.socket = session.webSocketTask(with: url)
    }
    
    func sendMove(){}
    func offerDraw(){}
    func recieveMove(){}
}
