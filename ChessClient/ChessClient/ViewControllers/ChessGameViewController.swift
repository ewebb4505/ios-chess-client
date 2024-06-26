//
//  ChessGameViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

class ChessGameViewController: UIViewController {
    let viewModel: ChessGameViewModel
    let gameConnection: GameConnection?
    let isLiveGame: Bool
    let thisPlayer: Player
    
    // properties that determine the size of the chess board.
    // this is only good for the current layout. In the future this should be adaptive when the user changes to landscape mode
    let screenWidth = UIScreen.main.bounds.width
    var boardSize: CGFloat { screenWidth }
    var squareSize: CGFloat { screenWidth / 8 }
    
    init(thisPlayer: Player, gameConnection: GameConnection? = nil, isLiveGame: Bool = false) {
        self.gameConnection = gameConnection
        self.isLiveGame = isLiveGame
        self.thisPlayer = thisPlayer
        viewModel = ChessGameViewModel(id: gameConnection?.gameId ?? "",
                                       whitePlayer: Player(id: gameConnection?.white ?? ""),
                                       blackPlayer: Player(id: gameConnection?.black ?? ""))
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up game details at the top of the view
        if let gameConnection {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
        
            let whitePlayerLabel = UILabel()
            let blackPlayerLabel = UILabel()
            let gameIdLabel = UILabel()
            whitePlayerLabel.text = "White: \(gameConnection.white) \(thisPlayer.id == gameConnection.white ? "(you)" : "")"
            blackPlayerLabel.text = "Black: \(gameConnection.black) \(thisPlayer.id == gameConnection.black ? "(you)" : "")"
            gameIdLabel.text = "GameId: \(gameConnection.gameId)"
            
            whitePlayerLabel.font = .systemFont(ofSize: 12)
            blackPlayerLabel.font = .systemFont(ofSize: 12)
            gameIdLabel.font = .systemFont(ofSize: 12)
            
            stackView.addArrangedSubview(whitePlayerLabel)
            stackView.addArrangedSubview(blackPlayerLabel)
            stackView.addArrangedSubview(gameIdLabel)
            
            view.addSubview(stackView)
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            
        }
        
        // setting up the chess board collection view controller
        let boardVC = ChessBoardCollectionViewController(thisPlayer: thisPlayer, viewModel: viewModel, squareSize: squareSize)
        addChild(boardVC)
        view.addSubview(boardVC.view)
        view.backgroundColor = .green
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        boardVC.view.widthAnchor.constraint(equalToConstant: boardSize).isActive = true
        boardVC.view.heightAnchor.constraint(equalToConstant: boardSize).isActive = true
    }
}
