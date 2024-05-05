//
//  InitialViewModel.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation

class InitialViewModel {
    private(set) var player: Player? = nil
    
    func setPlayer() {
        Task {
            do {
                let url = URL(string: "http://localhost:8080/user")!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let (data, _) = try await URLSession.shared.data(for: request)
                if let newPlayer = try? JSONDecoder().decode(Player.self, from: data) {
                    player = newPlayer
                } else {
                    print("Invalid Response")
                }
            } catch {
                print("Failed to Send POST Request \(error)")
            }
        }
    }
}
