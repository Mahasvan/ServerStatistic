//
//  StringFormatting.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/11/25.
//

import Foundation

func formatFloatAsInt(_ value: Float?) -> String {
    if value != nil {
        return String(Int(value!))
    }
    return "?"
}
