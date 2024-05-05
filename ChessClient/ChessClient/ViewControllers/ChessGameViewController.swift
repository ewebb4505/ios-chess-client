//
//  ChessGameViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

class ChessGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let viewModel: ChessGameViewModel
    
    // UI elements
    var board: UICollectionView!
    var boardLayout: UICollectionViewFlowLayout!
    static let squareSize: CGFloat = 44
    var boardSize: CGFloat {
        Self.squareSize * 8
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
        
        boardLayout = UICollectionViewFlowLayout()
        boardLayout.itemSize = CGSize(width: Self.squareSize, height: Self.squareSize)
        boardLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        boardLayout.minimumInteritemSpacing = 0
        boardLayout.minimumLineSpacing = 0
        
        board = UICollectionView(frame: .zero, collectionViewLayout: boardLayout)
        board.delegate = self
        board.dataSource = self
        board.register(ChessBoardSpot.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(board)
        view.backgroundColor = .green
        board.translatesAutoresizingMaskIntoConstraints = false
        board.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        board.widthAnchor.constraint(equalToConstant: boardSize).isActive = true
        board.heightAnchor.constraint(equalToConstant: boardSize).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot {
            let row = indexPath.section
            let fileIndex = indexPath.item
            let piece = viewModel.data.pieceAt(row: row, fileIndex: fileIndex)
            let spot = viewModel.data.spotAt(row: row, fileIndex: fileIndex)
            let isWhiteSquare = spot.isWhiteSqaure()
            cell.piece = piece
            cell.isWhiteSquare = isWhiteSquare
            cell.isWhitePiece = (row < 2) ? true : false
            cell.setupCell()
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
}
