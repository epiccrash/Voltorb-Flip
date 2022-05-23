//
//  GridView.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/6/22.
//

import SwiftUI

/// Draws the background lines for the game in different colors, the squares with point values, and the informational squares.
struct GridView: View {
    // Core model, used for getting the gameboard and calling logic
    @ObservedObject var gameModel: GameModel
    // Constant scaling factor for each cell (square) on the board
    var cellScale: CGFloat = 28 / 195
    // Constant scaling factors for each line
    var lineScale: CGFloat = 44 / 65
    var lineWeight: CGFloat = 8 / 195
    // Blank color used for the buffer square in the last row
    var blankColor = Color(hue: 0, saturation: 0, brightness: 0, opacity: 0)
    
    var body: some View {
        // Use GeometryReader to get screen width and height
        GeometryReader { metrics in
            ZStack {
                // Line size and thickness used for line width and height; depend on screen size and the above scaling factors
                let lineSize = metrics.size.width * lineScale
                let lineThickness = metrics.size.width * lineWeight
                // Size of each box depends on screen size and the above scaling factor
                let cellSize = metrics.size.width * cellScale
                
                // Background grid of overlapping lines, placed behind all squares
                LineView(lineSize: lineSize, lineThickness: lineThickness)
                
                // Box drawing
                VStack(spacing: lineThickness / 2) {
                    // Create 5 rows of squares
                    ForEach(0..<5) { row in
                        // Create a horizontal line of squares to form a row
                        HStack(spacing: lineThickness / 2) {
                            // Create 5 point squares per row
                            ForEach(0..<5) { col in
                                // Square with point values
                                GridSquare(width: cellSize, height: cellSize, lineThickness: lineThickness, row: row, col: col, gameModel: gameModel, isInfo: false)
                            }
                            // Information square, placed at the end of this row, within the last column
                            GridSquare(width: cellSize, height: cellSize, lineThickness: lineThickness, row: row, col: 5, gameModel: gameModel, isInfo: true)
                        }
                    }
                    
                    // Last row, consisting entirely of information squares
                    HStack(spacing: lineThickness / 2) {
                        // Create a near-complete row of information squares
                        ForEach(0..<5) { col in
                            GridSquare(width: cellSize, height: cellSize, lineThickness: lineThickness, row: 5, col: col, gameModel: gameModel, isInfo: true)
                        }
                        // Create empty rectangle at the end of the last row of information squares to act as a buffer and evenly space quares
                        Rectangle().frame(width: cellSize, height: cellSize).foregroundColor(blankColor)
                    }
                }
            }.frame(width: metrics.size.width, height: metrics.size.height, alignment: .center)
        }
    }
}
