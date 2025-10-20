//
//  CPUShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct CPUShortView: View {

    @Binding var usage: Float
    @Binding var temp: Float

    var body: some View {
        VStack(alignment: .leading) {
            Text("CPU")
            HStack(spacing: 0.0) {
                Text(String(Int(usage)))
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            .font(.system(size: 40, weight: .bold))
            Text("\(Int(temp))°C")
//                .font(.system(size: 30, weight: .bold))
        }
        .frame(width: 120, height: 120)
    }
}

private struct ShortComponentViewPreview: View {
    var body: some View {
        CPUShortView(usage: .constant(50.0), temp: .constant(75.0))
    }
}

#Preview {
    ZStack {
//        Rectangle().fill(Color.black).frame(width: 300, height: 300)
//        Image(systemName: "arrow.up.circle.fill").resizable().frame(width: 30, height: 30).padding()
        ShortComponentViewPreview()
    }
}
