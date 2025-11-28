//
//  CircularProgressBar.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI

struct CircularProgressBar: View {
    @Binding var lineWidth: CGFloat
    @Binding var progress: CGFloat
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: lineWidth
                )
                
            Circle()
                .trim(from: 0, to: progress)
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
    }
}

#Preview {
    CircularProgressBar(lineWidth: .constant(20.0), progress: .constant(0.5))
}
