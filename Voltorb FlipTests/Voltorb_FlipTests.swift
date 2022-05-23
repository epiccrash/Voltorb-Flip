//
//  Voltorb_FlipTests.swift
//  Voltorb FlipTests
//
//  Created by Joey Perrino on 5/6/22.
//

import XCTest
@testable import Voltorb_Flip

// Help on writing test cases in Swift from https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial
class Voltorb_FlipTests: XCTestCase {
    
    var gameModel: GameModel!

    override func setUpWithError() throws {
        // Create the game model
        try super.setUpWithError()
        gameModel = GameModel()
        gameModel.InitGameBoard()
    }

    override func tearDownWithError() throws {
        gameModel = nil
        try super.tearDownWithError()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Make sure the board has 25 numbers (5x5)
    func testGameModelBoardSizeIs5By5() throws {
        // Verify there are 5 rows
        XCTAssertEqual(gameModel.gameBoard.count, 5)
        
        // Verify there are 5 columns
        for i in 0..<5 {
            XCTAssertEqual(gameModel.gameBoard[i].count, 5)
        }
    }
    
    // Make sure the game's initial level is 1
    func testGameModelInitialLevelIs1() throws {
        XCTAssertEqual(gameModel.level, 1)
    }
    
    // Make sure the game's initial current score is 0
    func testGameModelInitialCurrentScoreIs0() throws {
        XCTAssertEqual(gameModel.currentScore, 0)
    }
    
    // Make sure the game's initial total score is 1
    func testGameModelInitialTotalScoreIs0() throws {
        XCTAssertEqual(gameModel.currentScore, 0)
    }
    
    // Make sure the game's current score increases via addition if it is 0 and we flip a 1
    func testGameModelChangeScoreWhen0With1Adds1() throws {
        // Change the current score by 1, so it equals 1 via addition
        gameModel.changeScore(num: 1)
        XCTAssertEqual(gameModel.currentScore, 1)
        XCTAssertEqual(gameModel.totalScore, 0)
    }
    
    // Make sure the game's current score increases via addition if it is 0 and we flip a number greater than 1
    func testGameModelChangeScoreWhen0WithNon1NumberAddsToScore() throws {
        // Change the current score by 2, so it equals 2 via addition
        gameModel.changeScore(num: 2)
        XCTAssertEqual(gameModel.currentScore, 2)
        XCTAssertEqual(gameModel.totalScore, 0)
    }
    
    // Make sure the game's current score doesn't change if it is greater than 0 and we flip a 1
    func testGameModelChangeScoreWhenGreaterThan0With1DoesNothing() throws {
        // Change the current score by 1, adding 1 to the current score of 0
        gameModel.changeScore(num: 1)
        let prevScore = gameModel.currentScore
        // Try to change the current score by 1, which shouldn't cause a change
        gameModel.changeScore(num: 1)
        XCTAssertEqual(gameModel.currentScore, prevScore)
        XCTAssertEqual(gameModel.totalScore, 0)
    }
    
    // Make sure the game's current score multiplies if it is 0 and we flip a number greater than 1
    func testGameModelChangeScoreWhenGreaterThan00WithNon1NumberMultipliesScore() throws {
        // Change the current score by 2, so it equals 2 via addition
        gameModel.changeScore(num: 2)
        XCTAssertEqual(gameModel.currentScore, 2)
        
        // Change the current score by 3, so it equals 3 via multiplication
        gameModel.changeScore(num: 3)
        XCTAssertEqual(gameModel.currentScore, 6)
        XCTAssertEqual(gameModel.totalScore, 0)
    }
    
    // Make sure we can add the current score to the total score to increase it
    func testCommitCurrentScoreAddsCurrentScoreToTotalScore() throws {
        // Get the initial current score and then add to or multiply it
        let initialCurrentScore = gameModel.currentScore
        gameModel.changeScore(num: 2)
        gameModel.changeScore(num: 3)
        gameModel.changeScore(num: 2)
        
        let prevCurrentScore = gameModel.currentScore
        let prevTotalScore = gameModel.totalScore
        // Verify that the current score is now greater than it was
        XCTAssertGreaterThan(gameModel.currentScore, initialCurrentScore)
        // Verify that the current score has not affected the total score yet
        XCTAssertEqual(gameModel.totalScore, 0)
        
        // Commit the current score and check that the current score was added to the total score
        gameModel.commitCurrentScore()
        XCTAssertEqual(gameModel.currentScore, 12)
        XCTAssertEqual(gameModel.totalScore, prevTotalScore + prevCurrentScore)
    }
    
    // Make sure we can add the current score to the total score to increase it when we advnace to the next game level
    func testAdvancingGameResetsCurrentScoreAndCommitsCurrentScoreToTotalScore() throws {
        // Get the initial current score and then add to or multiply it
        let initialCurrentScore = gameModel.currentScore
        gameModel.changeScore(num: 2)
        gameModel.changeScore(num: 3)
        gameModel.changeScore(num: 2)
        
        let prevCurrentScore = gameModel.currentScore
        let prevTotalScore = gameModel.totalScore
        // Verify that the current score is now greater than it was
        XCTAssertGreaterThan(gameModel.currentScore, initialCurrentScore)
        // Verify that the current score has not affected the total score yet
        XCTAssertEqual(gameModel.totalScore, 0)
        
        // Advance the game and check that the current score was added to the total score
        gameModel.advanceGame()
        XCTAssertEqual(gameModel.currentScore, 0)
        XCTAssertEqual(gameModel.totalScore, prevTotalScore + prevCurrentScore)
    }
    
    // Make sure that resetting the game only resets the current score and the game board
    func testResetGameResetsOnlyCurrentScoreAndGameBoard() throws {
        // Change the current score and verify it is no longer 0
        gameModel.changeScore(num: 2)
        gameModel.changeScore(num: 3)
        XCTAssertGreaterThan(gameModel.currentScore, 0)
        
        // Store old game values
        let prevTotalScore = gameModel.totalScore
        let prevLevel = gameModel.level
        let prevGameBoard = gameModel.gameBoard
        
        // Reset the game and verify that only the current score and game board are different
        gameModel.resetGame()
        XCTAssertEqual(gameModel.currentScore, 0)
        XCTAssertEqual(gameModel.totalScore, prevTotalScore)
        XCTAssertEqual(gameModel.level, prevLevel)
        // This line could possibly fail due to the same board being generated, but this is highly unlikely
        XCTAssertNotEqual(gameModel.gameBoard, prevGameBoard)
    }
    
    // Make sure that advancing the game when its level is between 1 and 8 results in the level being increased by 1
    func testAdvanceGameWhenGameLevelIsBelowMaximumIs1GreaterThanPreviousLevel() throws {
        // Verify that we start at level 1
        XCTAssertEqual(gameModel.level, 1)
        let prevLevel = gameModel.level
        
        // Advance the game and make sure that the new level is 1 higher than the previous level
        gameModel.advanceGame()
        XCTAssertGreaterThan(gameModel.level, prevLevel)
        XCTAssertEqual(gameModel.level, prevLevel + 1)
    }
    
    // Make sure that advancing the game when its level is 8 results in it staying at level 8
    func testAdvanceGameWhenGameLevelIsAtMaximumIsStillMaximum() throws {
        // Advance to the maximum level - the number of game boards
        let maximum = gameModel.levelArrangements.count
        while (gameModel.level < maximum) {
            gameModel.advanceGame()
        }
        XCTAssertEqual(gameModel.level, maximum)
        
        // Try to advance to level 9, automatically stop at level 8
        gameModel.advanceGame()
        XCTAssertEqual(gameModel.level, maximum)
    }
    
    // Make sure that reducing the game's level resets the current score without affecting the total score
    func testReduceGameResetsScore() throws {
        // Change the current score and advance the game to level 2
        gameModel.changeScore(num: 2)
        gameModel.changeScore(num: 3)
        gameModel.advanceGame()
        
        // Reduce the level and verify the current score is 0 while the total score is what it was before (6)
        let prevTotalScore = gameModel.totalScore
        gameModel.reduceGame()
        XCTAssertEqual(gameModel.currentScore, 0)
        XCTAssertEqual(gameModel.totalScore, prevTotalScore)
    }
    
    // Make sure that reducing the game's level when it's between 1 and 8 decreases the level by 1
    func testReduceGameWhenGameLevelIsAboveMinimumIs1LessThanPreviousLevel() throws {
        // Advance the game to level 2
        gameModel.advanceGame()
        XCTAssertEqual(gameModel.level, 2)
        let prevLevel = gameModel.level
        
        // Reduce the game's level and verify that it's decreased by 1
        gameModel.reduceGame()
        XCTAssertLessThan(gameModel.level, prevLevel)
        XCTAssertEqual(gameModel.level, prevLevel - 1)
    }
    
    // Make sure that reducing the game's level when it's at level 1
    func testReduceGameWhenGameLevelIsMinimumIsStillMinimum() throws {
        // Start from level 1
        let minimum = 1
        XCTAssertEqual(gameModel.level, minimum)
        
        // Reduce the game level and verify the level is still 1
        gameModel.reduceGame()
        XCTAssertEqual(gameModel.level, minimum)
    }
}
