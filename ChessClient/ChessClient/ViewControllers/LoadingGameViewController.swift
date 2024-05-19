//
//  LoadingGameViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/17/24.
//

import UIKit

class LoadingGameViewController: UIViewController {
    var player: Player? = nil
    var gameConnection: GameConnection? = nil
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { @MainActor in
            await getUserId()
            await addUserToPool()
            await getAUserPlayerToPlay()
            
            if player != nil && gameConnection != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: { [weak self] in
                    self?.navigationController?.pushViewController(ChessGameViewController(gameConnection: self?.gameConnection, isLiveGame: true), animated: true)
                }))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Task {
            await removeUser()
        }
    }
    
    func setupView() {
        activityIndicatorView.center = view.center
        activityIndicatorView.tintColor = .blue
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    @MainActor
    func getUserId() async {
        do {
            let url = URL(string: "http://127.0.0.1:8080/user")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (data, _) = try await URLSession.shared.data(for: request)
            if let newPlayer = try? JSONDecoder().decode(Player.self, from: data) {
                player = newPlayer
                print(player)
            } else {
                print("Invalid Response")
                return
            }
        } catch {
            print("Failed to Send POST Request \(error)")
        }
    }
    
    func addUserToPool() async {
        do {
            guard let player else { return }
            let url = URL(string: "http://127.0.0.1:8080/play?userId=\(player.id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("NOT A GOOD RESPONSE 1")
                return
            }
        } catch {
            print("Failed to Send POST Request \(error)")
        }
    }
    
    func getAUserPlayerToPlay() async {
        do {
            guard let player else { return }
            let url = URL(string: "http://127.0.0.1:8080/play?userId=\(player.id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("NOT A GOOD RESPONSE 2")
                return
            }
            
            if let connection = try? JSONDecoder().decode(GameConnection.self, from: data) {
                gameConnection = connection
                print(gameConnection)
            } else {
                print("Invalid Response 2")
                return
            }
        } catch {
            print("Failed to Send POST Request \(error)")
        }
    }
    
    func removeUser() async {
        // todo
    }
}

struct GameConnection: Codable {
    var gameId: String
    var white: String
    var black: String
}
