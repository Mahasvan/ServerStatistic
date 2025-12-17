//
//  CPUShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct CPUShortView: View {
    
    var cpuResponse: CPUResponseModel?
    var staticData: StaticServerInformationModel?
    
    @State private var isPopoverShown: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Image(systemName: "cpu")
                    .font(.title)
                Text("CPU")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            HStack(spacing: 0.0) {
                Text(formatFloatAsInt(cpuResponse?.currentUsage))
                    .font(.system(size: 40, weight: .bold))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: cpuResponse?.currentUsage)
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            Text("\(formatFloatAsInt(cpuResponse?.currentTemp))°C")
        }
        .onTapGesture {
            isPopoverShown = true
        }
        .frame(width: 120, height: 120)
        .popover(isPresented: $isPopoverShown, arrowEdge: .trailing) {
            CPUPopoverView(cpuResponse: cpuResponse, staticData: staticData)
        }
    }
}

private struct ShortComponentViewPreview: View {
    var cpuResponse = CPUResponseModel()
    var body: some View {
        CPUShortView(cpuResponse: cpuResponse)
    }
}

#Preview {
    ZStack {
        ShortComponentViewPreview()
    }
}
