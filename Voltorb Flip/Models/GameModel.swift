//
//  GameModel.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/7/22.
//

import Foundation

/// Enum used to keep track of the state of the game.
public enum GameState {
    case turnStart
    case turn
    case turnEnd
}

/// Main model class for the game. Handles core application logic, including setting the game board up, advancing or reducing the game level, and tracking overall game state.
class GameModel: ObservableObject {
    // Game board used in the current level; initialized in a later function
    @Published var gameBoard: [[Int]] = []
    // Score of the current round so far
    @Published var currentScore: Int = 0
    // Score across all rounds completed
    @Published var totalScore: Int = 0
    // Game's current level, between 1 and 8 (inclusive)
    @Published var level: Int = 1
    // Global game state
    @Published var gameState: GameState = GameState.turnStart
    
    // Total points shown in the info squares of the last column
    @Published var totalPointsInLastCol: [Int] = []
    // Total bombs shown in the info squares of the last column
    @Published var totalBombsInLastCol: [Int] = []
    // Total points shown in the info squares of the last row
    @Published var totalPointsInLastRow: [Int] = []
    // Total bombs shown in the info squares of the last row
    @Published var totalBombsInLastRow: [Int] = []
    // Total points and bombs
    var totalPoints = 0
    
    // All possible level arrangements, formatted as:
    // [number of twos, number of threes, number of bombs] across the entire board
    let levelArrangements = [
        [
            [3, 1, 6],
            [0, 3, 6],
            [5, 0, 6],
            [2, 2, 6],
            [4, 1, 6]
        ],
        [
            [1, 3, 7],
            [6, 0, 7],
            [3, 2, 7],
            [0, 4, 7],
            [5, 1, 7]
        ],
        [
            [2, 3, 8],
            [7, 0, 8],
            [4, 2, 8],
            [1, 4, 8],
            [6, 1, 8]
        ],
        [
            [3, 3, 8],
            [0, 5, 8],
            [8, 0, 10],
            [5, 2, 10],
            [2, 4, 10]
        ],
        [
            [7, 1, 10],
            [4, 3, 10],
            [1, 5, 10],
            [9, 0, 10],
            [6, 2, 10]
        ],
        [
            [3, 4, 10],
            [0, 6, 10],
            [8, 1, 10],
            [5, 3, 10],
            [2, 5, 10]
        ],
        [
            [7, 2, 10],
            [4, 4, 10],
            [1, 6, 13],
            [9, 1, 13],
            [6, 3, 10]
        ],
        [
            [0, 7, 10],
            [8, 2, 10],
            [5, 4, 10],
            [2, 6, 10],
            [7, 3, 10]
        ]
    ]

    /// Initializes the game board according to its level. The board is made to be of size 25 and consisting of only ones, randomly initialized and shuffled using the game arrangement selected, and then broken into a 5x5 2D array.
    func InitGameBoard() -> Void {
        // Create the board to be size 25 and initially filled with only ones
        var board = [Int](repeating: 1, count: 25)
        // Randomly select the arrangement to use in generating the board
        var arrangement: [Int] = levelArrangements[level - 1].randomElement()!
        // Index to track which cell of the board is filled in
        var index: Int = 0
        // Reset total points
        totalPoints = 1
        
        // Fill the front of the game board with as many twos as are specified in the board arrangement (index 0)
        while (arrangement[0] > 0) {
            board[index] = 2
            index += 1
            arrangement[0] -= 1
            totalPoints *= 2
        }
        
        // Fill the next chunk of the game board with as many threes as are specified in the board arrangement (index 1)
        while (arrangement[1] > 0) {
            board[index] = 3
            index += 1
            arrangement[1] -= 1
            totalPoints *= 3
        }
        
        // Fill the next chunk of the game board with as many bombs (zeroes) as are specified in the board arrangement (index 2)
        while (arrangement[2] > 0) {
            board[index] = 0
            index += 1
            arrangement[2] -= 1
        }
        
        // Randomize the location of the twos, threes, and zeroes
        board.shuffle()
        
        // Split the game board into a 5x5 2D array
        gameBoard = board.chunked(into: 5)
        
        // Initialize the total points and bombs in each column and row to be blank arrays
        totalPointsInLastCol = []
        totalBombsInLastCol = []
        totalPointsInLastRow = []
        totalBombsInLastRow = []
        
        // Loop 5 times and append the total points and bombs in each row or column to the relevant arrays
        for i in 0..<5 {
            totalPointsInLastCol.append(getTotalPoints(row: i, col: 5))
            totalBombsInLastCol.append(getTotalBombs(row: i, col: 5))
            totalPointsInLastRow.append(getTotalPoints(row: 5, col: i))
            totalBombsInLastRow.append(getTotalBombs(row: 5, col: i))
        }
        
        // Update the game state to be the main turn
        advanceState()
    }
    
    /// Gets the total points across a row or column to be shown in the relevant info square.
    func getTotalPoints(row: Int, col: Int) -> Int {
        // Info squares shown on the rightmost column
        if (col > row) {
            // Sum across the entire row
            return gameBoard[row].reduce(0, +)
        }
        // Info squares shown on the bottom row
        else {
            // Sum across the column
            var sum = 0
            for i in 0..<5 {
                sum += gameBoard[i][col]
            }
            return sum
        }
    }
    
    /// Gets the total number of bombs across a row or column to be shown in the relevant info square.
    func getTotalBombs(row: Int, col: Int) -> Int {
        // Info squares shown on the rightmost column
        if (col > row) {
            // Count zeroes across the entire row
            return gameBoard[row].filter({ $0 == 0 }).count
        }
        // Info squares shown on the bottom row
        else {
            // Sum the number of zeroes across the column
            var sum = 0
            for i in 0..<5 {
                if (gameBoard[i][col] == 0) {
                    sum += 1
                }
            }
            return sum
        }
    }
    
    /// Changes the current score based on the number provided and the current score. Can result in no action, addition, multiplication, or a game reset.
    func changeScore(num: Int) {
        // If the number is 0, reset the game to erase the current score
        if (num == 0) {
            advanceState()
            // resetGame()
        }
        // If the current score is 0, but the number provided is greater than 1, add that number to the current score
        else if (currentScore == 0) {
            currentScore += num
        }
        // If the current score is greater than 0, multiply the current score by the number provided
        else {
            currentScore *= num
        }
        
        // If the number of points the player has gotten equals the number of points possible, advance to the end of the turn
        if (totalPoints == currentScore) {
            advanceState()
        }
    }
    
    /// Adds the score of the current game round to the total score across all rounds.
    func commitCurrentScore() {
        totalScore += currentScore
    }
    
    /// Reset the game state, re-initializes the game board, and resets the currnet score. Can be called whether or not the turn was won or not.
    func resetGame() {
        // TODO: This should only be set to turn start after player confirms they want to move past turnEnd
        // Reset the game state
        // gameState = GameState.turnStart
        
        // Recreate the game board
        InitGameBoard()
        // Update the round's score to be 0
        currentScore = 0
    }
    
    /// Increases the game level, adds the current score to the total score, and resets the game (AKA, recreates the board and resets the current score).
    func advanceGame() {
        // Increase the game's level, unless it's already level 8
        level = min(levelArrangements.count, level + 1)
        // Add the current score to the total score across all rounds
        commitCurrentScore()
        // Reset the game
        resetGame()
    }
    
    /// Reduces the game level and resets the game (AKA, recreates the board and resets the current score).
    func reduceGame() {
        // Decrease the game's level, unless it's already level 1
        level = max(1, level - 1)
        // Reset the game
        resetGame()
    }
    
    /// Advances the game's state to the next state. The order is turnStart -> turn -> turnEnd -> repeat.
    func advanceState() {
        switch (gameState) {
        // If the game is at the start, move to the game's main turn
        case .turnStart:
            gameState = .turn
            break
        // If in the main turn, go to the end of the turn
        case .turn:
            gameState = .turnEnd
            break
        // If at the end of the turn, start a new turn
        case .turnEnd:
            gameState = .turnStart
            break
        }
    }
}

// Extension method for breaking an array into chunks of a specified length. Provided by: https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
