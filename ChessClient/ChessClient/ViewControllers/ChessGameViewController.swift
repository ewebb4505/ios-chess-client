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
        
//        boardLayout = UICollectionViewFlowLayout()
//        boardLayout.itemSize = CGSize(width: Self.squareSize, height: Self.squareSize)
//        boardLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        boardLayout.minimumInteritemSpacing = 0
//        boardLayout.minimumLineSpacing = 0
//        
//        board = UICollectionView(frame: .zero, collectionViewLayout: boardLayout)
//        board.delegate = self
//        board.dataSource = self
//        board.register(ChessBoardSpot.self, forCellWithReuseIdentifier: "cell")
//        self.view.addSubview(board)
//        view.backgroundColor = .green
//        board.translatesAutoresizingMaskIntoConstraints = false
//        board.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
//        board.widthAnchor.constraint(equalToConstant: boardSize).isActive = true
//        board.heightAnchor.constraint(equalToConstant: boardSize).isActive = true
        
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
