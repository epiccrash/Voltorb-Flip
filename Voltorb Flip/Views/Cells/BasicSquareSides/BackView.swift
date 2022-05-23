//
//  FrontView.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/19/22.
//

import SwiftUI

/// View of the back of a square, the side initially shown to a player before they flip it.
struct BackView: View {
    // Degree the square should flip on, passed in and modified by the parent view
    @Binding var degree: Double
    // The dimensions of the inner squares
    var innerSquareWidth: CGFloat
    var innerSquareHeight: CGFloat
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Create three rows of inner squares
                ForEach(0..<3) { i in
                    HStack(spacing: 0) {
                        // Create three columns of inner squares
                        ForEach(0..<3) { j in
                            // Alternate the colors of each inner square
                            Rectangle().foregroundColor(Color(CGColor(red: 0, green: (i + j) % 2 == 0 ? 0.6 : 0.8, blue: 0, alpha: 1.0))).frame(width: innerSquareWidth, height: innerSquareHeight)
                        }
                    }
                }
            }
        // Rotate the square based on the degree passed in by the BasicSquare parent view
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0.0, y: 1.0, z: 0.0), perspective: 0)
    }
}
