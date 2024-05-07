//
//  GameRequestWebSocketProtocol.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import Combine

protocol GameRequestWebSocketProtocol {
    var session: URLSession { get }
    var url: URL { get }
    var socket: URLSessionWebSocketTask { get }
    var passthrough: PassthroughSubject<URLSessionWebSocketTask.Message, Error> { get }
    
    func sendGameRequest()
    func leave()
    func pool()
}
