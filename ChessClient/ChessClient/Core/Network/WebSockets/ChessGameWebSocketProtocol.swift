//
//  ChessGameWebSocketProtocol.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import Combine

protocol ChessGameWebSocketProtocol {
    var session: URLSession { get }
    var url: URL { get }
    var socket: URLSessionWebSocketTask { get }
    var passthrough: PassthroughSubject<URLSessionWebSocketTask.Message, Error> { get }
    
    func sendMove()
    func offerDraw()
    func recieveMove()
}
