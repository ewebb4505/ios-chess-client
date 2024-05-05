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

class ChessGameViewModel {
    let whitePlayer: Player
    let blackPlayer: Player
    
    let session: ChessGameWebSocketProtocol
    
    let data: Board = Board.setBoard()
    
    init(whitePlayer: Player,
         blackPlayer: Player,
         session: ChessGameWebSocketProtocol = ChessGameWebSocket(session: URLSession(configuration: .default, delegate: ChessGameWebSocketDelegate(), delegateQueue: .main), url: URL(string: "wss://127.0.0.1:8080/")!)) {
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
        self.session = session
    }
}

class ChessBoardSpot: UICollectionViewCell {
    var piece: Piece? = nil
    var isWhiteSquare: Bool = true
    var isWhitePiece: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("something")
    }
    
    func setupCell() {
        self.backgroundColor = isWhiteSquare ? .white : .black
        if let piece, let image = piece.getImage(isWhite: isWhitePiece) {
            let sizedImage = resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
            let imageView = UIImageView(image: sizedImage)
            self.contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        }
    }
}

extension Piece {
    func getImage(isWhite: Bool = true) -> UIImage? {
        switch self {
        case .P:
            isWhite ? UIImage(named: "black_pawn") : UIImage(named: "white_pawn")
        case .K:
            isWhite ? UIImage(named: "black_king") : UIImage(named: "white_king")
        case .N:
            isWhite ? UIImage(named: "black_knight") : UIImage(named: "white_knight")
        case .Q:
            isWhite ? UIImage(named: "black_queen") : UIImage(named: "white_queen")
        case .B:
            isWhite ? UIImage(named: "black_bishop") : UIImage(named: "white_bishop")
        case .R:
            isWhite ? UIImage(named: "black_rook") : UIImage(named: "white_rook")
        }
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
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
