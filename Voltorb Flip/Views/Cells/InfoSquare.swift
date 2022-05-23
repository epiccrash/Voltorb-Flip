//
//  InfoSquare.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/6/22.
//

import SwiftUI

/// View for informaitonal squares, which show the number of points and bombs per row and column.
struct InfoSquare: View {
    // Row and column assignment of this info square
    var row: Int
    var col: Int
    // The core model passed in by parent views
    @ObservedObject var gameModel: GameModel
    
    // Scale of this square overall
    var innerScaleFactor: CGFloat = 6/7
    // Scale offset
    var innerScaleDiff: CGFloat = 2
    
    var body: some View {
        GeometryReader { metrics in
            let innerWidth: CGFloat = metrics.size.width * innerScaleFactor
            let innerHeight: CGFloat = metrics.size.height * innerScaleFactor
            let heightBuffer: CGFloat = innerHeight / 12
            let quarterHeight: CGFloat = innerHeight / 4
            
            ZStack {
                Rectangle().fill(colors[(row + col) - 5]).frame(width: innerWidth, height: innerHeight)
                VStack(spacing: 0) {
                    // Points
                    ZStack {
                        Rectangle().frame(width: innerWidth, height: quarterHeight + heightBuffer).foregroundColor(blankColor)
                        Text(String(row > col ? gameModel.totalPointsInLastRow[col] : gameModel.totalPointsInLastCol[row])).fontWeight(.bold)
                    }
                    Rectangle().fill(borderColor).frame(width: innerWidth, height: quarterHeight / 3)
                    // Bombs
                    ZStack {
                     Rectangle().frame(width: innerWidth, height: 2 * quarterHeight + heightBuffer).foregroundColor(blankColor)
                        Text(String(row > col ? gameModel.totalBombsInLastRow[col] : gameModel.totalBombsInLastCol[row])).fontWeight(.bold)
                    }
                }
            }.frame(width: metrics.size.width, height: metrics.size.height, alignment: .center)
        }
    }
}
