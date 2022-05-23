//
//  BasicSquare.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/6/22.
//

import SwiftUI

/// Square that stores points.
struct BasicSquare: View {
    // Row and column number of this square
    var row: Int
    var col: Int
    // Core model used for number retrieval and changing score
    @ObservedObject var gameModel: GameModel
    
    // Variable storing if this square is flipped
    @State var isFlipped = false
    // Degrees required to flip a square on its axis
    @State var backDegree: Double = 0.0
    @State var frontDegree: Double = -90.0
    // Duration of flip animation
    var animationDuration: Double = 0.1
    // Scale of this square overall
    var innerScaleFactor: CGFloat = 6/7
    // Scale offset
    var innerScaleDiff: CGFloat = 2
    
    var body: some View {
        // GeometryReader to use inherited width and height
        GeometryReader { metrics in
            // Width and height of a square depends on the screen size and the above scale factor
            let innerWidth: CGFloat = metrics.size.width * innerScaleFactor
            let innerHeight: CGFloat = metrics.size.height * innerScaleFactor
            
            // Layer the front (numbered side) of a square behind its back (green side)
            ZStack {
                FrontView(num: $gameModel.gameBoard[row][col], degree: $frontDegree, innerWidth: innerWidth, innerHeight: innerHeight, innerScaleDiff: innerScaleDiff)
                BackView(degree: $backDegree, innerSquareWidth: innerWidth / 3, innerSquareHeight: innerHeight / 3)
            }.frame(width: metrics.size.width, height: metrics.size.height, alignment: .center).onTapGesture {
                // Flip the square and perform game logic if we flip the square and it's the turn stage of the game
                if (gameModel.gameState == GameState.turn && !isFlipped) {
                    flip()
                    gameModel.changeScore(num: gameModel.gameBoard[row][col])
                }
            }
        }
    }
    
    /// Visually flips the square. Follows the implementation shown here: https://betterprogramming.pub/card-flip-animation-in-swiftui-45d8b8210a00
    func flip() {
        // Flip the square
        isFlipped.toggle()
        // If we just flipped the square, play a flip animation
        if isFlipped {
            // Rotate each side to a different 90 degree angle to toggle the visibility of each
            withAnimation(Animation.linear(duration: animationDuration)) {
                backDegree = 90.0
            }
            withAnimation(Animation.linear(duration: animationDuration).delay(animationDuration)) {
                frontDegree = 0.0
            }
        }
        // If the square flips to its back, play a flip animation in the opposite direction
        else {
            // Rotate each side to a different 90 degree angle to toggle the visibility of each
            withAnimation(Animation.linear(duration: animationDuration)) {
                frontDegree = -90.0
            }
            withAnimation(Animation.linear(duration: animationDuration).delay(animationDuration)) {
                backDegree = 0.0
            }
        }
    }
}
