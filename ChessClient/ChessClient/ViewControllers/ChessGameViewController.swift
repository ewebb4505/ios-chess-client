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
    
    // UI elements
    var boardSize: CGFloat {
        44 * 8
    }
    
    init(whitePlayer: Player = Player(id: UUID()), blackPlayer: Player = Player(id: UUID())) {
        viewModel = ChessGameViewModel(whitePlayer: whitePlayer, blackPlayer: blackPlayer)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boardVC = ChessBoardCollectionViewController(board: viewModel.data)
        addChild(boardVC)
        
        view.addSubview(boardVC.view)
        view.backgroundColor = .green
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        boardVC.view.widthAnchor.constraint(equalToConstant: boardSize).isActive = true
        boardVC.view.heightAnchor.constraint(equalToConstant: boardSize).isActive = true
    }
}
