//
//  Extensions.swift
//  BrainTrainingGame
//
//  Created by Alessandre Livramento on 03/10/22.
//

import SwiftUI

extension Color {

    static let color1 = Color("Color 1")
    static let color2 = Color("Color 2")
    static let color3 = Color("Color 3")
    static let color4 = Color("Color 4")
    static let color5 = Color("Color 5")
    static let color6 = Color("Color 6")
    static let color7 = Color("Color 7")
    static let color8 = Color("Color 8")
    static let color9 = Color("Color 9")
    static let color10 = Color(red: 0.76, green: 0.15, blue: 0.26)
    static let color11 = Color(red: 0.15, green: 0.76, blue: 0.26)

    static let background = LinearGradient(gradient: Gradient(colors: [Color("Color 8").opacity(0.8), Color("Color 2").opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let background1 =   RadialGradient(stops: [
        .init(color: Color(red: 0.76, green: 0.15, blue: 0.26).opacity(0.8), location: 0.4),
        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45).opacity(0.8), location: 0.4)
    ], center: .top, startRadius: 200, endRadius: 400)

}
