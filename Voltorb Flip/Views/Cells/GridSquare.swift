//
//  GridSquare.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/10/22.
//

import SwiftUI

/// Wrapper for each square displayed in the grid.
struct GridSquare: View {
    // Width and height passed in from parent view
    var width: CGFloat
    var height: CGFloat
    // Line thickness used for inner square spacing
    var lineThickness: CGFloat
    // Row and column number of this square
    var row: Int
    var col: Int
    // Core model used for number retrieval
    @ObservedObject var gameModel: GameModel
    // Boolean saying if this square should be a square with info on the rest of the row/column
    var isInfo: Bool
    
    var body: some View {
        ZStack {
            // Create a white square with a black square layered on top
            Rectangle().fill(borderColor)
            Rectangle().background(Color.black).frame(width: width - lineThickness / 2, height: height - lineThickness / 2)
            // Draw an informational square if marked as informational
            if (isInfo) {
                InfoSquare(row: row, col: col, gameModel: gameModel).frame(alignment: .center)
            }
            // Draw a square with a point value if not marked as informational
            else {
                BasicSquare(row: row, col: col, gameModel: gameModel).frame(alignment: .center)
            }
        }.frame(width: width, height: height)
    }
}
