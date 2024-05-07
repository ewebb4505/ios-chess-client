//
//  GameRequestWebSocketDelegate.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation

class GameRequestWebSocketDelegate: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket did close")
    }
}
