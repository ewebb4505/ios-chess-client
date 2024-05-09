//
//  ChessBoardCollectionViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import UIKit
import Combine

class ChessBoardCollectionViewController: UICollectionViewController {
    
    static let squareSize: CGFloat = 44
    var data: Board
    var isWhitesTurn: Bool = true
    var isMakingMove: Bool = false
    var pieceWantingToBeMoved: Piece? = nil
    
    private lazy var dataSource = createDataSource()

    
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
        collectionView.register(ChessBoardSpot.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = dataSource
        dataSource.apply(dataSource.createInitialSnapshot())
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Int, ChessBoardSpotModel> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot else {
                fatalError("Could not dequeue proper ChessBoardSpot class")
            }
            
            guard let self else {
                fatalError("Could not dequeue proper ChessBoardSpot class")
            }
            print(itemIdentifier.id, indexPath.row, indexPath.section)
            let row = 7 - indexPath.section
            let fileIndex = indexPath.row
            let (spot, piece) = self.getSpotAndPiece(row, fileIndex)
            itemIdentifier.piece = piece
            cell.setSpotModel(itemIdentifier)
            cell.setView()
            return cell
        }
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
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot {
//            let row = 7 - indexPath.section
//            let fileIndex = indexPath.row
//            // print("row being set: \(row) / fileIndex being set: \(fileIndex) / item \(indexPath.item)")
//            
//            let (spot, piece) = getSpotAndPiece(row, fileIndex)
//            // print(spot, piece)
//            
//            cell.setupModel(spot: spot, piece: piece)
//            return cell
//        }
//        fatalError("Unable to dequeue subclassed cell")
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // first determine if it's this users turn. if not we will do premoves later. if so get spot and pieces
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot {
            if isWhitesTurn {
                let row = 7 - indexPath.section
                let fileIndex = indexPath.row
    
                print("TAPPED ON \n row being set: \(row) / fileIndex being set: \(fileIndex) / item \(indexPath.item)")
                
                let (spot, piece) = getSpotAndPiece(row, fileIndex)
                print(spot.debugDescription, piece.debugDescription)
                // next highlight valid sqaures where this piece can move
                isMakingMove.toggle()
                if isMakingMove {
                    guard let piece else { return }
                    guard let spotsThisPieceCanGo = piece.reaches(from: spot, on: data) else {
                        print("THIS PIECE CANT GO ANYWHERE FOR A REASON")
                        return
                    }
                    pieceWantingToBeMoved = cell.getPiece()
                    for spot in spotsThisPieceCanGo {
                        print(spot)
                        print(spot.row, Spot.files[spot.fileIndex],7 - spot.fileIndex+1)
                        let indexPath = IndexPath(row: 3, section: 5)
                        var possibleSpot = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChessBoardSpot
                        // TODO: figure out why this doesn't work
                        print(dataSource.itemIdentifier(for: indexPath)?.id)
                        guard let model = dataSource.itemIdentifier(for: indexPath) else {
                            print("RETURNED")
                            return
                        }
                        model.shouldAddHighlight = true
                        
                        var snapshot = dataSource.snapshot()
                        snapshot.reloadItems([model])
                        dataSource.apply(snapshot)
                        
                    }
                } else {
                    print("TODO")
                }
            }
        } else {
            fatalError("Unable to dequeue subclassed cell")
        }
    }
    
    private func getSpotAndPiece(_ row: Int, _ fileIndex: Int) -> (Spot, Piece?) {
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
        var spots: Set<Spot>? = nil
        switch self {
        case .WP:
            // TODO: need to determine if this is the first time this pawn is moving. If so consider going up: 2
            let spotAheadOfWhitePawn = spot.move(up: 1)
            let spotAttackedToRightOfWhitePawn = spot.move(up: 1, right: 1)
            let spotAttackedToLeftOfWhitePawn = spot.move(up: 1, left: 1)
            
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
        return spots
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

extension UICollectionViewDiffableDataSource<Int, ChessBoardSpotModel> {
    func createInitialSnapshot() -> NSDiffableDataSourceSnapshot<Int, ChessBoardSpotModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChessBoardSpotModel>()
        let row8 = [ChessBoardSpotModel(square: .a8), ChessBoardSpotModel(square: .b8), ChessBoardSpotModel(square: .c8), ChessBoardSpotModel(square: .d8), ChessBoardSpotModel(square: .e8), ChessBoardSpotModel(square: .f8), ChessBoardSpotModel(square: .g8), ChessBoardSpotModel(square: .h8)]
        let row7 = [ChessBoardSpotModel(square: .a7), ChessBoardSpotModel(square: .b7), ChessBoardSpotModel(square: .c7), ChessBoardSpotModel(square: .d7), ChessBoardSpotModel(square: .e7), ChessBoardSpotModel(square: .f7), ChessBoardSpotModel(square: .g7), ChessBoardSpotModel(square: .h7)]
        let row6 = [ChessBoardSpotModel(square: .a6), ChessBoardSpotModel(square: .b6), ChessBoardSpotModel(square: .c6), ChessBoardSpotModel(square: .d6), ChessBoardSpotModel(square: .e6), ChessBoardSpotModel(square: .f6), ChessBoardSpotModel(square: .g6), ChessBoardSpotModel(square: .h6)]
        let row5 = [ChessBoardSpotModel(square: .a5), ChessBoardSpotModel(square: .b5), ChessBoardSpotModel(square: .c5), ChessBoardSpotModel(square: .d5), ChessBoardSpotModel(square: .e5), ChessBoardSpotModel(square: .f5), ChessBoardSpotModel(square: .g5), ChessBoardSpotModel(square: .h5)]
        let row4 = [ChessBoardSpotModel(square: .a4), ChessBoardSpotModel(square: .b4), ChessBoardSpotModel(square: .c4), ChessBoardSpotModel(square: .d4), ChessBoardSpotModel(square: .e4), ChessBoardSpotModel(square: .f4), ChessBoardSpotModel(square: .g4), ChessBoardSpotModel(square: .h4)]
        let row3 = [ChessBoardSpotModel(square: .a3), ChessBoardSpotModel(square: .b3), ChessBoardSpotModel(square: .c3), ChessBoardSpotModel(square: .d3), ChessBoardSpotModel(square: .e3), ChessBoardSpotModel(square: .f3), ChessBoardSpotModel(square: .g3), ChessBoardSpotModel(square: .h3)]
        let row2 = [ChessBoardSpotModel(square: .a2), ChessBoardSpotModel(square: .b2), ChessBoardSpotModel(square: .c2), ChessBoardSpotModel(square: .d2), ChessBoardSpotModel(square: .e2), ChessBoardSpotModel(square: .f2), ChessBoardSpotModel(square: .g2), ChessBoardSpotModel(square: .h2)]
        let row1 = [ChessBoardSpotModel(square: .a1), ChessBoardSpotModel(square: .b1), ChessBoardSpotModel(square: .c1), ChessBoardSpotModel(square: .d1), ChessBoardSpotModel(square: .e1), ChessBoardSpotModel(square: .f1), ChessBoardSpotModel(square: .g1), ChessBoardSpotModel(square: .h1)]
        snapshot.appendSections([7, 6, 5, 4, 3, 2, 1, 0])
        snapshot.appendItems(row8, toSection: 7)
        snapshot.appendItems(row7, toSection: 6)
        snapshot.appendItems(row6, toSection: 5)
        snapshot.appendItems(row5, toSection: 4)
        snapshot.appendItems(row4, toSection: 3)
        snapshot.appendItems(row3, toSection: 2)
        snapshot.appendItems(row2, toSection: 1)
        snapshot.appendItems(row1, toSection: 0)
        return snapshot
    }
}
