//
//  Spot.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation

enum Spot: String, CaseIterable, Hashable {
    case a8, b8, c8, d8, e8, f8, g8, h8,
         a7, b7, c7, d7, e7, f7, g7, h7,
         a6, b6, c6, d6, e6, f6, g6, h6,
         a5, b5, c5, d5, e5, f5, g5, h5,
         a4, b4, c4, d4, e4, f4, g4, h4,
         a3, b3, c3, d3, e3, f3, g3, h3,
         a2, b2, c2, d2, e2, f2, g2, h2,
         a1, b1, c1, d1, e1, f1, g1, h1
}

extension Spot {
    static func construct(row: Int, file: String) -> Spot? {
        Spot(rawValue: file + row.description)
    }
    
    var row: Int {
        Int(self.rawValue.last!.description)!
    }
    
    var file: String {
        self.rawValue.first!.lowercased()
    }
    
    var fileIndex: Int {
        Self.files.firstIndex(of: self.rawValue.first!.lowercased())!
    }
    
    static var files: [String] {
        ["a", "b", "c", "d", "e", "f", "g", "h"]
    }
    
    func move(up: Int = 0, down: Int = 0, left: Int = 0, right: Int = 0) -> Self? {
        guard !(up > 8 || down > 8 || left > 8 || right > 8) else {
            return nil
        }
        
        let num = self.row
        let file = self.file
        guard let currentFileIndex = Self.files.firstIndex(of: file)?.advanced(by: 0) else {
            return nil
        }
        
        let isStillInBounds = (num + up <= 8)
        && (num - down >= 1)
        && ((currentFileIndex+1) - left >= 1)
        &&  ((currentFileIndex+1) + right <= 8)
        
        guard isStillInBounds else {
            return nil
        }
        
        let newNum = num + (up - down)
        let newFileIndex = currentFileIndex + (right - left)
        let newFile = Self.files[newFileIndex]
        
        return Self.construct(row: newNum, file: newFile)
    }
    
    var adjacent: Set<Self> {
        var set: Set<Self> = []
        set.insertIfNotNull(self.move(up: 1))
        set.insertIfNotNull(self.move(down: 1))
        set.insertIfNotNull(self.move(right: 1))
        set.insertIfNotNull(self.move(left: 1))
        set.insertIfNotNull(self.move(up: 1, right: 1))
        set.insertIfNotNull(self.move(up: 1, left: 1))
        set.insertIfNotNull(self.move(down: 1, right: 1))
        set.insertIfNotNull(self.move(down: 1, left: 1))
        return set
    }
    
    func isWhiteSqaure() -> Bool {
        let row = self.row
        let file = self.file
        if (row == 1 || row == 3 || row == 5 || row == 7) {
             return (file == "b" || file == "d" || file == "f" || file == "h")
        } else {
            return (file == "a" || file == "c" || file == "e" || file == "g")
        }
    }
}

extension Set<Spot> {
    mutating func insertIfNotNull(_ element: Spot?) {
        guard let element else { return }
        self.insert(element)
    }
}
