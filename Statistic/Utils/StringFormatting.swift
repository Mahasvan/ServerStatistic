//
//  StringFormatting.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/11/25.
//

import Foundation

extension Float {
    func asIntCeil() -> Int {
        Int(ceil(self))
    }
    
    var asNumericString: String {
        return self.asIntCeil().description
    }
}

extension Optional where Wrapped == Float {
  var asNumericString: String {
      return self?.asIntCeil().description ?? "?"
  }
}
