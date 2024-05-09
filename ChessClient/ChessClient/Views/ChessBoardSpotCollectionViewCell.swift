//
//  ChessBoardSpotCollectionViewCell.swift
//  ChessClient
//
//  Created by Evan Webb on 5/5/24.
//

import Foundation
import UIKit
import Combine

class ChessBoardSpot: UICollectionViewCell {
    private(set) var spotModel: ChessBoardSpotModel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("something")
    }
    
    func setSpotModel(_ model: ChessBoardSpotModel) {
        spotModel = model
    }
    
    func setView() {
        guard let spotModel else { return }
        spotModel.isWhiteSquare = spotModel.square.isWhiteSqaure()
        if spotModel.shouldAddHighlight {
            backgroundColor = .orange
        } else {
            backgroundColor = spotModel.isWhiteSquare ? .white : .black
        }
        if let image = spotModel.piece?.image {
            let sizedImage = resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
            let imageView = UIImageView(image: sizedImage)
            self.contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        }
    }
    
    func getPiece() -> Piece? {
        spotModel?.piece
    }
    
    func setShouldHighlight(_ shouldHighlight: Bool) {
        spotModel?.shouldAddHighlight = shouldHighlight
    }
    
    func setBackgroundColor() {
        guard let spotModel else {
            return
        }
        if spotModel.shouldAddHighlight {
            backgroundColor = .orange
        } else {
            backgroundColor = spotModel.isWhiteSquare ? .white : .black
        }
    }
}

fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
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
