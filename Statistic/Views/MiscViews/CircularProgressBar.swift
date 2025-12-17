//
//  CircularProgressBar.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI

struct CircularProgressBar: View {
    var lineWidth: CGFloat
    var diameter: CGFloat
    @Binding var progress: CGFloat // 0 to 100
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: lineWidth
                )
                
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
                .shadow(radius: 5)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(width: diameter)
    }
}

#Preview {
    CircularProgressBar(lineWidth: 10, diameter: 100, progress: .constant(0.5))
}
