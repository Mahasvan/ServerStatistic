//
//  ShortComponentView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI

struct ShortComponentView: View {
    private let lineWidth : CGFloat = 15
    private let padding: CGFloat = 20
    private let frameSize: CGFloat = 200
    private let animationTime =  0.5
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    @Binding var titleText: String
    @Binding var subtitleText: String
    @Binding var progress: CGFloat
    
    
    func updateProgress(_ value: CGFloat) {
        withAnimation {
            progress = value
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(padding)
                .foregroundStyle(Color.primary)
                .opacity(0.5)
                .colorInvert()
                .shadow(radius: 10)
            VStack {
                Text(titleText)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                Text(subtitleText)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 20))
                    .animation(.easeInOut(duration: animationTime), value: subtitleText)
                    .multilineTextAlignment(.center)
            }
            .frame(width: frameSize-padding-3*lineWidth, height: frameSize-padding-3*lineWidth)
            
            
            CircularProgressBar(lineWidth: .constant(lineWidth), progress: $progress)
                .padding(padding)
        }
        .frame(width: frameSize, height: frameSize)
        .padding(padding)
        
    }
}

private struct ShortComponentViewPreview: View {
    @State private var progress: CGFloat = 0.0
    
    func getSubtitle(progress: CGFloat) -> String {
        return "\(Int(progress * 100))%"
    }
    
    var body: some View {
        ShortComponentView(
            titleText: .constant("CPU"),
            subtitleText: .constant(getSubtitle(progress: progress)),
            progress: $progress)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    progress = 0.5
                }
            }
    }
}

#Preview {
    ZStack {
        Rectangle().fill(Color.gray).frame(width: 300, height: 300)
//        Image(systemName: "arrow.up.circle.fill").resizable().frame(width: 30, height: 30).padding()
        ShortComponentViewPreview()
    }
}
