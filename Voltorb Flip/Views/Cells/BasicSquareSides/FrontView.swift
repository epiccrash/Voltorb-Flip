//
//  BackView.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/19/22.
//

import SwiftUI

/// View of the front of a square, the side hidden from the player before they flip it.
struct FrontView: View {
    // Number shown in the view, passed in and modified by the parent view
    @Binding var num: Int
    // Degree the square should flip on, passed in and modified by the parent view
    @Binding var degree: Double
    // The dimensions of each square created in this view
    var innerWidth: CGFloat
    var innerHeight: CGFloat
    // Buffer to create overlapping, bordered squares
    var innerScaleDiff: CGFloat
    // Width of the border on the number shown
    var numberBorderWidth: CGFloat = 1.5
    // Size of each number
    var numberSize: CGFloat = 24.0
    
    var body: some View {
        ZStack {
            // Bottom level square; creates a border
            Rectangle().foregroundColor(.black).frame(width: innerWidth, height: innerHeight)
            // Second-level square; creates an additional border
            Rectangle().foregroundColor(.red).frame(width: innerWidth - 2 * innerScaleDiff, height: innerHeight - 2 * innerScaleDiff)
            // Primary square
            Rectangle().foregroundColor(.gray).frame(width: innerWidth - 4 * innerScaleDiff, height: innerHeight - 4 * innerScaleDiff)
            // Display number, with an outline; taken from https://stackoverflow.com/questions/57334125/how-to-make-text-stroke-in-swiftui
            ZStack {
                // ZStack to create an outline by displacing the number in different directions
                ZStack {
                    Text(String(num)).offset(x:  numberBorderWidth, y:  numberBorderWidth)
                    Text(String(num)).offset(x: -numberBorderWidth, y: -numberBorderWidth)
                    Text(String(num)).offset(x: -numberBorderWidth, y:  numberBorderWidth)
                    Text(String(num)).offset(x:  numberBorderWidth, y: -numberBorderWidth)
                }.foregroundColor(.white).font(.system(size: numberSize, weight: .bold))
                // Actual numbered display
                Text(String(num))
            }.foregroundColor(.black).font(.system(size: numberSize, weight: .bold))
        // Rotate the square based on the degree passed in by the BasicSquare parent view
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0.0, y: 1.0, z: 0.0), perspective: 0)
    }
}
