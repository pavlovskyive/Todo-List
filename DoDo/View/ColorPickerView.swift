//
//  ColorPickerView.swift
//  TodoProj
//
//  Created by Vsevolod Pavlovskyi on 10.05.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct Collection<Content: View, Data: Hashable>: View {
    var data: [Data]
    let viewBuilder: (Data) -> Content
    let cols: Int
    let spacing: CGFloat

    init(data: [Data], cols: Int = 3, spacing: CGFloat = 5,_ viewBuilder: @escaping (Data) -> Content) {
        self.data = data
        self.cols = cols
        self.spacing = spacing
        self.viewBuilder = viewBuilder
    }
    
    private func cell(colIndex: Int, rowIndex: Int) -> some View {
        let cellIndex = (rowIndex * cols) + colIndex
        return ZStack {
            if cellIndex < data.count {
                self.viewBuilder(data[cellIndex])
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.setupView(geometry: geometry).frame(minHeight: geometry.frame(in: .global).height)
            }
        }
    }

    private func setupView(geometry: GeometryProxy) -> some View {
        let rowRemainder = Double(data.count).remainder(dividingBy: Double(cols))
        let rowCount = data.count / cols + (rowRemainder == 0 ? 0 : 1)
        let frame = geometry.frame(in: .global)
        let totalSpacing = Int(spacing) * (cols - 1)
        let cellWidth = (frame.width - CGFloat(totalSpacing))/CGFloat(cols)

        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(0...rowCount-1, id: \.self) { row in
                HStack(spacing: self.spacing) {
                    ForEach(0...self.cols-1, id: \.self) { col in
                        self.cell(colIndex: col, rowIndex: row)
                        .frame(maxWidth: cellWidth)
                    }
                }
            }
        }
    }
}

struct ColorPickerView: View {
    @Binding var choosenColor: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Color Tag:")
                .padding([.top, .leading])
            
            Collection(data: colors, cols: 4, spacing: 0) { color in
                ZStack {
                    Circle()
                        .foregroundColor(Color(self.choosenColor == color ? .systemBackground : .systemGray5))
                        .frame(width: 60, height: 60)
                        .animation(.default)
                    
                    Image(systemName: "smallcircle.fill.circle.fill")
                        .foregroundColor(Color(color))
                        .font(.system(size: 35, weight: .black))
                        .onTapGesture {
                            self.choosenColor = color
                        }
                }
            }
            .frame(height: CGFloat(colors.count / 4 * 80))
            .padding()
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(20)
    }
  
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(choosenColor: .constant("blue"))
    }
}
