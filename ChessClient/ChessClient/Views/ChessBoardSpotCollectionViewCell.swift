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
    var piece: Piece? = nil
    var square: Spot? = nil
    var isWhiteSquare: Bool = true
    var isWhitePiece: Bool = true
    // TODO: implement this
    var shouldAddHighlight: Bool = false
    var colorChangeSubscriber: AnyCancellable? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("something")
    }
    
    func setupCell() {
        changeCellBackgroundColor()
        if let piece, let image = piece.image {
            let sizedImage = resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
            let imageView = UIImageView(image: sizedImage)
            self.contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        }
    }
    
    func changeCellBackgroundColor() {
        self.backgroundColor = shouldAddHighlight ? .orange : isWhiteSquare ? .white : .black
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
