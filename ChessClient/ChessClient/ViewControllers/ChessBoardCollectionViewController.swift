//
//  ChessBoardCollectionViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import UIKit

class ChessBoardCollectionViewController: UICollectionViewController {
    
    static let squareSize: CGFloat = 44
    var data: Board
    var isWhitesTurn: Bool = true
    var isMakingMove: Bool = false
    var pieceWantingToBeMoved: Piece? = nil
    
    init(board: Board) {
        self.data = board
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Self.squareSize, height: Self.squareSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChessBoardSpot.self, forCellWithReuseIdentifier: "cell")
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot {
            let (spot, piece) = getSpotAndPiece(indexPath)
            let isWhiteSquare = spot.isWhiteSqaure()
            cell.piece = piece
            cell.isWhiteSquare = isWhiteSquare
            cell.isWhitePiece = (indexPath.section < 2) ? true : false
            cell.setupCell()
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // first determine if it's this users turn. if not we will do premoves later. if so get spot and pieces
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot {
            if isWhitesTurn {
                let (spot, piece) = getSpotAndPiece(indexPath)
                print(spot.debugDescription, piece.debugDescription)
                // next highlight valid sqaures where this piece can move
                isMakingMove.toggle()
                if isMakingMove {
                    guard let piece else { return }
                    guard let spotsThisPieceCanGo = piece.reaches(from: spot, on: data) else {
                        print("THIS PIECE CANT GO ANYWHERE FOR A REASON")
                        return
                    }
                    pieceWantingToBeMoved = cell.piece
                    for spots in spotsThisPieceCanGo {
                        var possibleSpot = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: IndexPath(row: spots.row, section: spots.fileIndex)) as! ChessBoardSpot
                        possibleSpot.shouldAddHighlight = true
                    }
                } else {
                    print("TODO")
                }
            }
        }
        
        fatalError("Unable to dequeue subclassed cell")
    }
    
    private func getSpotAndPiece(_ indexPath: IndexPath) -> (Spot, Piece?) {
        let row = indexPath.section
        let fileIndex = indexPath.item
        let piece = data.pieceAt(row: row, fileIndex: fileIndex)
        let spot = data.spotAt(row: row, fileIndex: fileIndex)
        return (spot, piece)
    }
}

extension Spot: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.rawValue)"
    }
}

extension Piece: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.rawValue)"
    }
}

extension Piece {
    func reaches(from spot: Spot,
                 on board: Board) -> Set<Spot>? {
        switch self {
        case .WP:
            let spotAheadOfWhitePawn = spot.move(up: 1)
            let spotAttackedToRightOfWhitePawn = spot.move(up: 1, right: 1)
            let spotAttackedToLeftOfWhitePawn = spot.move(up:1, left: 1)
            var spots: Set<Spot>? = nil
            
            if let spotAheadOfWhitePawn {
                spots = .init()
                if board[spotAheadOfWhitePawn] == nil {
                    spots?.insert(spotAheadOfWhitePawn)
                }
                
                if let spotAttackedToRightOfWhitePawn,
                    let rightAttackedPiece = board[spotAttackedToRightOfWhitePawn],
                   (rightAttackedPiece == .BP || rightAttackedPiece == .BB || rightAttackedPiece == .BK || rightAttackedPiece == .BN || rightAttackedPiece == .BQ || rightAttackedPiece == .BR) {
                    spots?.insert(spotAttackedToRightOfWhitePawn)
                }
                
                if let spotAttackedToLeftOfWhitePawn, let leftAttackedPiece = board[spotAttackedToLeftOfWhitePawn],
                   (leftAttackedPiece == .BP || leftAttackedPiece == .BB || leftAttackedPiece == .BK || leftAttackedPiece == .BN || leftAttackedPiece == .BQ || leftAttackedPiece == .BR) {
                    spots?.insert(spotAttackedToLeftOfWhitePawn)
                }
            } else {
                // if there's no spot ahead of the pawn this means this pawn can be promoted
                return spots
            }
        case .BP:
            return .init()
        case .WK:
            return .init()
        case .BK:
            return .init()
        case .WN:
            return .init()
        case .BN:
            return .init()
        case .WQ:
            return .init()
        case .BQ:
            return .init()
        case .WB:
            return .init()
        case .BB:
            return .init()
        case .WR:
            return .init()
        case .BR:
            return .init()
        }
        return nil
    }
    //    fun Pieces.squaresAttackedBy(piece: Piece, at: BoardSpot, isWhitePiece: Boolean = true): Set<BoardSpot> {
    //        when(piece) {
    //            Piece.Q -> {
    //                val attackedSpots = BoardSpot.entries.toMutableList()
    //                attackedSpots.remove(at)
    //                return attackedSpots.toSet()
    //            }
    //
    //            Piece.K -> {
    //                return at.getAdjacent()
    //            }
    //
    //            Piece.R -> {
    //                val row = at.row()
    //                val file = at.file()
    //
    //                // todo: change this to map over BoardSpot.files
    //                val spotsOnRow = mutableSetOf (
    //                    BoardSpot.construct(row, "a"),
    //                    BoardSpot.construct(row, "b"),
    //                    BoardSpot.construct(row, "c"),
    //                    BoardSpot.construct(row, "d"),
    //                    BoardSpot.construct(row, "e"),
    //                    BoardSpot.construct(row, "f"),
    //                    BoardSpot.construct(row, "g"),
    //                    BoardSpot.construct(row, "h")
    //                ).filterNotNull().toMutableSet()
    //
    //                // todo: change this to loop
    //                val spotsOnFile = mutableSetOf (
    //                    BoardSpot.construct(1, file),
    //                    BoardSpot.construct(2, file),
    //                    BoardSpot.construct(3, file),
    //                    BoardSpot.construct(4, file),
    //                    BoardSpot.construct(5, file),
    //                    BoardSpot.construct(6, file),
    //                    BoardSpot.construct(7, file),
    //                    BoardSpot.construct(8, file),
    //                ).filterNotNull().toMutableSet()
    //
    //                spotsOnRow.remove(at)
    //                spotsOnFile.remove(at)
    //                return (spotsOnFile + spotsOnRow).toSet()
    //            }
    //
    //            Piece.B -> {
    //                val attackingSpots: MutableSet<BoardSpot> = mutableSetOf()
    //
    //                for (i in 1..8) {
    //                    at.next(up = i, left = i)?.let { attackingSpots.add(it) }
    //                    at.next(up = i, right = i)?.let { attackingSpots.add(it) }
    //                    at.next(down = i, left = i)?.let { attackingSpots.add(it) }
    //                    at.next(down = i, right = i)?.let { attackingSpots.add(it) }
    //                }
    //
    //                return attackingSpots
    //            }
    //
    //            Piece.N -> {
    //                return setOfNotNull(
    //                    at.next(up = 2, right = 1),
    //                    at.next(up = 2, left = 1),
    //                    at.next(up = 1, right = 2),
    //                    at.next(up = 1, left = 2),
    //                    at.next(down = 2, right = 1),
    //                    at.next(down = 2, left = 1),
    //                    at.next(down = 1, right = 2),
    //                    at.next(down = 1, left = 2),
    //                )
    //            }
    //            Piece.P -> {
    //                return if (isWhitePiece) {
    //                    setOfNotNull(
    //                        at.next(up = 1, right = 1),
    //                        at.next(up = 1, left = 1),
    //                    )
    //                } else {
    //                    setOfNotNull(
    //                        at.next(down = 1, right = 1),
    //                        at.next(down = 1, left = 1),
    //                    )
    //                }
    //            }
    //        }
    //    }
}
