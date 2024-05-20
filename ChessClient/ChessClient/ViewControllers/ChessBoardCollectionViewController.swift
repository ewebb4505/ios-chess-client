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
    let viewModel: ChessGameViewModel
    let thisPlayer: Player
    
    private lazy var dataSource = createDataSource()

    init(thisPlayer: Player, viewModel: ChessGameViewModel, squareSize: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: squareSize, height: squareSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.thisPlayer = thisPlayer
        self.viewModel = viewModel
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
        dataSource.apply(dataSource.createInitialSnapshot(thisPlayerIsWhitePieces: thisPlayer.id == viewModel.whitePlayer.id))
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Int, ChessBoardSpotModel> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot else {
                fatalError("Could not dequeue proper ChessBoardSpot class")
            }
            
            guard let self else {
                fatalError("Could not dequeue proper ChessBoardSpot class")
            }
            print("RELOADING: ", itemIdentifier.id, indexPath.row, indexPath.section)
            
            let row = thisPlayer.id == viewModel.whitePlayer.id ? 7 - indexPath.section : indexPath.section
            let fileIndex = indexPath.row
            let (_, piece) = self.getSpotAndPiece(row, fileIndex)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // first determine if it's this users turn. if not we will do premoves later. if so get spot and pieces
        if collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChessBoardSpot != nil {
            if viewModel.playersTurn == .white {
                // TODO: make it so that the white player can't tap on a black piece
                // get the row and file where the user tapped.
                let row = 7 - indexPath.section
                let fileIndex = indexPath.row
                print("TAPPED ON \n row being set: \(row) / fileIndex being set: \(fileIndex) / item \(indexPath.item)")
                
                // determine the spot and possible piece that was tapped using row and fileIndex.
                let (spot, piece) = getSpotAndPiece(row, fileIndex)
                print(spot.debugDescription, piece.debugDescription)
                
                // next highlight valid sqaures where this piece can move
                // guard let piece else { return }
                
                
                if viewModel.tapTracker.firstTap == nil {
                    guard let piece else { return }
                    guard didSelectValidSquareOnFirstTap(spot: spot) else {
                        return
                    }
                    
                    guard let spotsThisPieceCanGo = piece.reaches(from: spot, on: viewModel.data) else {
                        print("THIS PIECE CANT GO ANYWHERE FOR A REASON")
                        return
                    }
                    
                    print(spotsThisPieceCanGo)
                    var snapshot = dataSource.snapshot()
                    var modelsForSnapshot: [ChessBoardSpotModel] = []
                    
                    for spot in spotsThisPieceCanGo {
                        let indexPath = spot.toIndexPath()
                        guard let model = dataSource.itemIdentifier(for: indexPath) else {
                            print("RETURNED")
                            return
                        }
                        model.shouldAddHighlight = true
                        modelsForSnapshot.append(model)
                        viewModel.highlightedSpots.insert(model)
                    }
                    
                    snapshot.reloadItems(modelsForSnapshot)
                    dataSource.apply(snapshot)
                    viewModel.handleTap(spot: spot, piece: piece)
                } else {
                    var snapshot = dataSource.snapshot()
                    var modelsForSnapshot: [ChessBoardSpotModel] = []
                    // handle second tap
                    // TODO: if the user taps on another piece then they want to see where that piece can move instead of this current piece.
                    
                    // first make sure this square tapped if a valid move for the piece first tapped
                    // - does the square have a piece from the op? if so update the board. if not just move the piece to that valid square
                    guard let model = dataSource.itemIdentifier(for: indexPath) else {
                        return
                    }
                    
                    guard let firstTap = viewModel.tapTracker.firstTap else { return }
                    let previousTapIndexPath = firstTap.spot.toIndexPath()
                    let previousTapPiece = firstTap.piece
                    
                    // THIS IS RETURNING WRONG MODEL
                    guard let previousTapModel = dataSource.itemIdentifier(for: previousTapIndexPath) else {
                        return
                    }
                    
                    print("Second Tap: \(model.id)")
                    
                    if let attackedPiece = model.piece {
                        viewModel.data[previousTapModel.id] = nil as Piece?
                        viewModel.data[model.id] = previousTapPiece
                        model.piece = previousTapPiece
                        previousTapModel.piece = nil
                        model.shouldAddHighlight = false
                        previousTapModel.shouldAddHighlight = false
                        modelsForSnapshot.append(model)
                        modelsForSnapshot.append(previousTapModel)
                    } else {
                        viewModel.data[previousTapModel.id] = nil as Piece?
                        viewModel.data[model.id] = previousTapPiece
                        model.piece = previousTapPiece
                        previousTapModel.piece = nil
                        model.shouldAddHighlight = false
                        previousTapModel.shouldAddHighlight = false
                        modelsForSnapshot.append(model)
                        modelsForSnapshot.append(previousTapModel)
                    }
                    
                    viewModel.highlightedSpots.forEach { spot in
                        spot.shouldAddHighlight = false
                        if !modelsForSnapshot.contains(spot) {
                            modelsForSnapshot.append(spot)
                        }
                        
                    }
                    viewModel.highlightedSpots = []
                    
                    snapshot.reloadItems(modelsForSnapshot)
                    dataSource.apply(snapshot)
                    viewModel.tapTracker.firstTap = nil
                    viewModel.tapTracker.secondTap = nil
                    viewModel.playersTurn = .black
                    // don't forget to reset the tap tracker after this move.
                }
            } else {
                // black players turn
                let row = 7 - indexPath.section
                let fileIndex = indexPath.row
                print("TAPPED ON \n row being set: \(row) / fileIndex being set: \(fileIndex) / item \(indexPath.item)")
                
                // determine the spot and possible piece that was tapped using row and fileIndex.
                let (spot, piece) = getSpotAndPiece(row, fileIndex)
                print(spot.debugDescription, piece.debugDescription)
                
                if viewModel.tapTracker.firstTap == nil {
                    guard let piece else { return }
                    guard didSelectValidSquareOnFirstTap(spot: spot) else {
                        return
                    }
                    guard let spotsThisPieceCanGo = piece.reaches(from: spot, on: viewModel.data) else {
                        print("THIS PIECE CANT GO ANYWHERE FOR A REASON")
                        return
                    }
                    
                    print(spotsThisPieceCanGo)
                    var snapshot = dataSource.snapshot()
                    var modelsForSnapshot: [ChessBoardSpotModel] = []
                    
                    for spot in spotsThisPieceCanGo {
                        let indexPath = spot.toIndexPath()
                        guard let model = dataSource.itemIdentifier(for: indexPath) else {
                            print("RETURNED")
                            return
                        }
                        model.shouldAddHighlight = true
                        modelsForSnapshot.append(model)
                        viewModel.highlightedSpots.insert(model)
                    }
                    
                    snapshot.reloadItems(modelsForSnapshot)
                    dataSource.apply(snapshot)
                    viewModel.handleTap(spot: spot, piece: piece)
                } else {
                    var snapshot = dataSource.snapshot()
                    var modelsForSnapshot: [ChessBoardSpotModel] = []
                    // handle second tap
                    // TODO: if the user taps on another piece then they want to see where that piece can move instead of this current piece.
                   
                    // first make sure this square tapped if a valid move for the piece first tapped
                    // - does the square have a piece from the op? if so update the board. if not just move the piece to that valid square
                    guard let model = dataSource.itemIdentifier(for: indexPath) else {
                        return
                    }
                    
                    guard let firstTap = viewModel.tapTracker.firstTap else { return }
                    let previousTapIndexPath = firstTap.spot.toIndexPath()
                    let previousTapPiece = firstTap.piece
                    
                    guard let previousTapModel = dataSource.itemIdentifier(for: previousTapIndexPath) else {
                        return
                    }
                    
                    print("Second Tap: \(model.id)")
                    
                    if let attackedPiece = model.piece {
                        viewModel.data[previousTapModel.id] = nil as Piece?
                        viewModel.data[model.id] = previousTapPiece
                        model.piece = previousTapPiece
                        previousTapModel.piece = nil
                        model.shouldAddHighlight = false
                        previousTapModel.shouldAddHighlight = false
                        modelsForSnapshot.append(model)
                        modelsForSnapshot.append(previousTapModel)
                    } else {
                        viewModel.data[previousTapModel.id] = nil as Piece?
                        viewModel.data[model.id] = previousTapPiece
                        // get the previous taps spot and index path
                        model.piece = previousTapPiece
                        previousTapModel.piece = nil
                        model.shouldAddHighlight = false
                        previousTapModel.shouldAddHighlight = false
                        modelsForSnapshot.append(model)
                        modelsForSnapshot.append(previousTapModel)
                    }
                    
                    viewModel.highlightedSpots.forEach { spot in
                        spot.shouldAddHighlight = false
                        if !modelsForSnapshot.contains(spot) {
                            modelsForSnapshot.append(spot)
                        }
                        
                    }
                    
                    viewModel.highlightedSpots = []
                    snapshot.reloadItems(modelsForSnapshot)
                    self.dataSource.apply(snapshot)
                    viewModel.tapTracker.firstTap = nil
                    viewModel.tapTracker.secondTap = nil
                    viewModel.playersTurn = .white
                }
                
            }
        } else {
            fatalError("Unable to dequeue subclassed cell")
        }
    }
    
    private func getSpotAndPiece(_ row: Int, _ fileIndex: Int) -> (Spot, Piece?) {
        let piece = viewModel.data.pieceAt(row: row, fileIndex: fileIndex)
        let spot = viewModel.data.spotAt(row: row, fileIndex: fileIndex)
        return (spot, piece)
    }
    
    private func didSelectValidSquareOnFirstTap(spot: Spot) -> Bool {
        if viewModel.playersTurn == .black {
            return !(viewModel.data[spot]??.isWhite ?? true)
        } else {
            return viewModel.data[spot]??.isWhite ?? false
        }
    }
}

extension Spot: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.rawValue)"
    }
    
    func toIndexPath() -> IndexPath {
        let row = self.row
        let file = self.fileIndex
        print(" row: \(row), file: \(file) \n indexPath.row: \(file), indexPath.file: \(row+1)")
    
        return IndexPath(row: file, section: 7-row+1)
    }
}

extension Piece: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.rawValue)"
    }
}

extension UICollectionViewDiffableDataSource<Int, ChessBoardSpotModel> {
    func createInitialSnapshot(thisPlayerIsWhitePieces: Bool) -> NSDiffableDataSourceSnapshot<Int, ChessBoardSpotModel> {
        if thisPlayerIsWhitePieces {
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
        } else {
            var snapshot = NSDiffableDataSourceSnapshot<Int, ChessBoardSpotModel>()
            let row8 = [ChessBoardSpotModel(square: .a8), ChessBoardSpotModel(square: .b8), ChessBoardSpotModel(square: .c8), ChessBoardSpotModel(square: .d8), ChessBoardSpotModel(square: .e8), ChessBoardSpotModel(square: .f8), ChessBoardSpotModel(square: .g8), ChessBoardSpotModel(square: .h8)]
            let row7 = [ChessBoardSpotModel(square: .a7), ChessBoardSpotModel(square: .b7), ChessBoardSpotModel(square: .c7), ChessBoardSpotModel(square: .d7), ChessBoardSpotModel(square: .e7), ChessBoardSpotModel(square: .f7), ChessBoardSpotModel(square: .g7), ChessBoardSpotModel(square: .h7)]
            let row6 = [ChessBoardSpotModel(square: .a6), ChessBoardSpotModel(square: .b6), ChessBoardSpotModel(square: .c6), ChessBoardSpotModel(square: .d6), ChessBoardSpotModel(square: .e6), ChessBoardSpotModel(square: .f6), ChessBoardSpotModel(square: .g6), ChessBoardSpotModel(square: .h6)]
            let row5 = [ChessBoardSpotModel(square: .a5), ChessBoardSpotModel(square: .b5), ChessBoardSpotModel(square: .c5), ChessBoardSpotModel(square: .d5), ChessBoardSpotModel(square: .e5), ChessBoardSpotModel(square: .f5), ChessBoardSpotModel(square: .g5), ChessBoardSpotModel(square: .h5)]
            let row4 = [ChessBoardSpotModel(square: .a4), ChessBoardSpotModel(square: .b4), ChessBoardSpotModel(square: .c4), ChessBoardSpotModel(square: .d4), ChessBoardSpotModel(square: .e4), ChessBoardSpotModel(square: .f4), ChessBoardSpotModel(square: .g4), ChessBoardSpotModel(square: .h4)]
            let row3 = [ChessBoardSpotModel(square: .a3), ChessBoardSpotModel(square: .b3), ChessBoardSpotModel(square: .c3), ChessBoardSpotModel(square: .d3), ChessBoardSpotModel(square: .e3), ChessBoardSpotModel(square: .f3), ChessBoardSpotModel(square: .g3), ChessBoardSpotModel(square: .h3)]
            let row2 = [ChessBoardSpotModel(square: .a2), ChessBoardSpotModel(square: .b2), ChessBoardSpotModel(square: .c2), ChessBoardSpotModel(square: .d2), ChessBoardSpotModel(square: .e2), ChessBoardSpotModel(square: .f2), ChessBoardSpotModel(square: .g2), ChessBoardSpotModel(square: .h2)]
            let row1 = [ChessBoardSpotModel(square: .a1), ChessBoardSpotModel(square: .b1), ChessBoardSpotModel(square: .c1), ChessBoardSpotModel(square: .d1), ChessBoardSpotModel(square: .e1), ChessBoardSpotModel(square: .f1), ChessBoardSpotModel(square: .g1), ChessBoardSpotModel(square: .h1)]
            snapshot.appendSections([0, 1, 2, 3, 4, 5, 6, 7])
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
}
