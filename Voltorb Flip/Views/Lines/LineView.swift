//
//  LineView.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/11/22.
//

import SwiftUI

/// Draws a background grid of overlapping lines.
struct LineView: View {
    // Line size and thickness used for width and height depending onwhether a line is horizontal or vertical
    var lineSize: CGFloat
    var lineThickness: CGFloat
    
    var body: some View {
        // Use GeometryReader to get inherited width and height
        GeometryReader { metrics in
            ZStack {
                // Horizontal line drawing
                VStack(spacing: 3 * lineThickness) {
                    // Create 5 horizontal lines
                    ForEach(0..<5) { row in
                        // Place a line with color on top of a slightly larger white line
                        ZStack {
                            Rectangle().frame(width: lineSize, height: lineThickness, alignment: .center).border(borderColor, width: lineThickness / 2)
                            Rectangle().fill(colors[row]).frame(width: lineSize, height: lineThickness / 2, alignment: .center)
                        }
                    }
                    // Create a blank line to even out spacing between the other lines
                    Rectangle().frame(width: lineSize, height: lineThickness, alignment: .center).foregroundColor(blankColor)
                }
                
                // Vertical line drawing
                HStack(spacing: 3 * lineThickness) {
                    // Create 5 vertical lines
                    ForEach(0..<5) { col in
                        // Place a line with color on top of a slightly larger white line
                        ZStack {
                            Rectangle().frame(width: lineThickness, height: lineSize, alignment: .center).border(borderColor, width: lineThickness / 2)
                            Rectangle().fill(colors[col]).frame(width: lineThickness / 2, height: lineSize, alignment: .center)
                        }
                    }
                    // Create a blank line to even out spacing between the other lines
                    Rectangle().frame(width: lineThickness, height: lineSize, alignment: .center).foregroundColor(blankColor)
                }
            }.frame(width: metrics.size.width, height: metrics.size.height, alignment: .center)
        }
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(lineSize: 16, lineThickness: 8)
    }
}
