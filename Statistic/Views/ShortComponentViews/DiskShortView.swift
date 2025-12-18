//
//  DiskShortView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 20/10/25.
//

import SwiftUI

struct DiskShortView: View {
    
    var diskResponse: DiskResponseModel?
    var staticData: StaticServerInformationModel?
    
    @State private var isPopoverShown: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Image(systemName: "internaldrive")
                    .font(.title)
                Text("Disk")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            HStack(spacing: 0.0) {
                Text("\((diskResponse?.currentUsage).asNumericString)")
                    .font(.system(size: 40, weight: .bold))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: diskResponse?.currentUsage)
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            Text("of \((staticData?.diskTotalCapacity).asNumericString) GB")
        }
        .frame(width: 120, height: 120)
        .onTapGesture {
            isPopoverShown = true
        }
        .popover(isPresented: $isPopoverShown, arrowEdge: .trailing) {
            DiskPopoverView(diskResponse: diskResponse, staticData: staticData)
        }
    }
}

#Preview {
    DiskShortView(diskResponse: DiskResponseModel())
}
