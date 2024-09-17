//
//  GridRow.swift
//  VGrid
//
//  Created by Elyes Derouiche on 16/09/2024.
//
import Foundation
import SwiftUI

public enum GridRow {
    case fixed(ratio: CGFloat, height: CGFloat?, alignment: Alignment?)
    case `default`

    var alignment: Alignment? {
        switch self {
        case .fixed(_,_, let alignment):
            return alignment
        case .default:
            return .center
        }
    }

    static var Default: GridRow {
        return GridRow.default
    }
}
