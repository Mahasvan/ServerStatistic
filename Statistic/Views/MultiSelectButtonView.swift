//
//  MultiSelectButtonView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 13/09/25.
//  https://medium.com/@jpmtech/create-a-custom-multi-select-button-in-swiftui-ebe1de8cd8aa
//

import SwiftUI

struct MultiSelectButtonView<T: Identifiable & Hashable, Content: View>: View {
    let options: [T]
    @Binding var selection: [T?]
    @ViewBuilder let content: (T) -> Content

    /*
     init methods aren't required for SwiftUI to work, however in this example,
     I wanted to see only the variables at the call site (not the parameter names for the views).
     */
    init(
        _ options: [T],
        _ selection: Binding<[T?]>,
        @ViewBuilder _ content: @escaping (T) -> Content
    ) {
        self.options = options
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        // I have chosen to use a Group here to allow the parent component decide how this view should be displayed
        Group {
            ForEach(options, id: \.self) { option in
                Button {
                    if selection.contains(option) {
                        selection.removeAll { $0 == option }
                    } else {
                        selection.append(option)
                    }
                } label: {
                    content(option)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
