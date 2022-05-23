//
//  GameView.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/6/22.
//

import SwiftUI

/// General wrapper for the entire game view.
struct GameView: View {
    // Core model for game logic; changes internal data regaularly, so it's an observed object
    @ObservedObject var gameModel: GameModel = GameModel()
    // Tracker for when the model is fully loaded
    @State var modelLoaded = false
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            // Vertical stack of the main game view
            VStack {
                // Display the score and total score
                // TODO: Better formatting required
                Text("Score: \(gameModel.currentScore)\nTotal score: \(gameModel.totalScore)").frame(alignment: .leading).onAppear {
                    // When the text component is loaded, create a new game board and mark the model as totally loaded
                    gameModel.InitGameBoard()
                    modelLoaded = true
                }
                // If the model is fully loaded, create the main game view via a grid
                if (modelLoaded) {
                    GridView(gameModel: gameModel).frame(alignment: .trailing)
                }
            }
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
