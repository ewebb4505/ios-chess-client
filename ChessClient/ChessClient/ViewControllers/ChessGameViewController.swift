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
        boardLayout.itemSize = CGSize(width: 40, height: 40)
        
        board = UICollectionView(frame: .zero, collectionViewLayout: boardLayout)
        board.delegate = self
        board.dataSource = self
        board.register(ChessBoardSpot.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(board)
        view.backgroundColor = .green
        board.translatesAutoresizingMaskIntoConstraints = false
        board.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        board.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        board.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        board.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        //board.widthAnchor.constraint(equalToConstant: 40*8).isActive = true
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
            let data = viewModel.data[indexPath.section][indexPath.item]
            cell.backgroundColor = data == "a1" || data == "c1" || data == "e1" || data == "g1" ? .black : .gray
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
}

class ChessGameViewModel {
    let whitePlayer: Player
    let blackPlayer: Player
    
    let session: ChessGameWebSocketProtocol
    
    let data: [[String]] = [["a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8"],
                          ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"],
                          ["a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6"],
                          ["a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5"],
                          ["a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4"],
                          ["a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3"],
                          ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"],
                          ["a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"]]
    
    init(whitePlayer: Player,
         blackPlayer: Player,
         session: ChessGameWebSocketProtocol = ChessGameWebSocket(session: URLSession(configuration: .default, delegate: ChessGameWebSocketDelegate(), delegateQueue: .main), url: URL(string: "wss://127.0.0.1:8080/")!)) {
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
        self.session = session
    }
}

class ChessBoardSpot: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("something")
    }
    
    func setupCell(color: UIColor) {
        self.backgroundColor = color
    }
}

/*
 final class CustomFlowLayout: UICollectionViewFlowLayout {

     let cellSpacing: CGFloat = 0

     override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         if let attributes = super.layoutAttributesForElements(in: rect) {
             for (index, attribute) in attributes.enumerated() {
                 if index == 0 { continue }
                 let prevLayoutAttributes = attributes[index - 1]
                 let origin = prevLayoutAttributes.frame.maxX
                 if (origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize.width) {
                     attribute.frame.origin.x = origin + cellSpacing
                 }
             }
             return attributes
         }
         return nil
     }

 }
 */
