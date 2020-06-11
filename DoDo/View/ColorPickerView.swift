//
//  ColorPickerView.swift
//  TodoProj
//
//  Created by Vsevolod Pavlovskyi on 10.05.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

// View that put data in columns
struct Collection<Content: View, Data: Hashable>: View {
    
    // data given (conforms to hashable protocol)
    var data: [Data]
    
    // construct view from closure
    let viewBuilder: (Data) -> Content
    
    // columns number
    let cols: Int
    
    // space between columns
    let spacing: CGFloat

    // initialization
    init(data: [Data], cols: Int = 3, spacing: CGFloat = 5,_ viewBuilder: @escaping (Data) -> Content) {
        self.data = data
        self.cols = cols
        self.spacing = spacing
        self.viewBuilder = viewBuilder
    }
    
    // cell view
    private func cell(colIndex: Int, rowIndex: Int) -> some View {
        let cellIndex = (rowIndex * cols) + colIndex
        return ZStack {
            if cellIndex < data.count {
                self.viewBuilder(data[cellIndex])
            }
        }
    }
    
    // main layout
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.setupView(geometry: geometry).frame(minHeight: geometry.frame(in: .global).height)
            }
        }
    }
    
    // container
    private func setupView(geometry: GeometryProxy) -> some View {
        
        // remainder from division of number of elements on number of columns
        let rowRemainder = Double(data.count).remainder(dividingBy: Double(cols))
        // if there are remaining item, add one more row
        let rowCount = data.count / cols + (rowRemainder == 0 ? 0 : 1)
        // width and height of parent
        let frame = geometry.frame(in: .global)
        // space between columnts
        let totalSpacing = Int(spacing) * (cols - 1)
        // cell width
        let cellWidth = (frame.width - CGFloat(totalSpacing))/CGFloat(cols)

        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(0...rowCount-1, id: \.self) { row in
                // row
                HStack(spacing: self.spacing) {
                    ForEach(0...self.cols-1, id: \.self) { col in
                        // element
                        self.cell(colIndex: col, rowIndex: row)
                            .frame(maxWidth: cellWidth)
                    }
                }
            }
        }
    }
}

struct ColorPickerView: View {
    
    // Binding variables
    // (two-way connection with parent view)
    // -----------------
    // currenty choosen color
    @Binding var choosenColor: String
    
    // Haptic feedback
    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // UI content and layout
    // ---------------------
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Color Tag:")
                .padding([.top, .leading])
            
            // colors put in columns by 4
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
                            self.hapticSuccess()
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
