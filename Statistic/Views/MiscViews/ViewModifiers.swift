//
//  ViewModifiers.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 29/11/25.
//

import Foundation
import SwiftUI



struct GlassButton: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 26.0, *) {
            content.buttonStyle(.glass)
        } else {
            content // fallback inherits default button style
        }
    }
}
