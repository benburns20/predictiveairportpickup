//
//  CustomSegmentedControl.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/13/22.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding public var selection: Int
        
    private let size: CGSize
    private let segmentLabels: [Int]
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            // # Background shape
            RoundedRectangle(cornerRadius: 10)
                .frame(width: size.width, height: size.height)
                .foregroundColor(.gray)
                .opacity(0.2)
            
            // # Selection background
            RoundedRectangle(cornerRadius: 10)
                .frame(width: segmentWidth(size), height: size.height - 6)
                .foregroundColor(.white)
                .offset(x: calculateSegmentOffset(size))
                .animation(Animation.easeInOut(duration: 0.5))
            
            // # Labels
            HStack(spacing: 0) {
                SegmentLabel(title: segmentLabels[0], width: segmentWidth(size), textColour: Color.black, idx: 0)
                    .onTapGesture {
                        selection = 0
//                        print("\(0)")
                    }
                
                SegmentLabel(title: segmentLabels[1], width: segmentWidth(size), textColour: Color.black, idx: 1)
                    .onTapGesture {
                        selection = 1
//                        print("\(1)")
                    }
            }
        }
    }
    
    public init(selection: Binding<Int>, size: CGSize, segmentLabels: [Int]) {
            self._selection = selection
            self.size = size
            self.segmentLabels = segmentLabels
    }
    
    private func segmentWidth(_ mainSize: CGSize) -> CGFloat {
        var width = (mainSize.width / CGFloat(segmentLabels.count))
        if width < 0 {
            width = 0
        }
        return width
    }
    
    private func calculateSegmentOffset(_ mainSize: CGSize) -> CGFloat {
        if selection == 0 {
            return (segmentWidth(mainSize) * CGFloat(selection)) + 3
        } else {
            return (segmentWidth(mainSize) * CGFloat(selection)) - 3
        }
    }
}

fileprivate struct SegmentLabel: View {
    
    let title: Int
    let width: CGFloat
    let textColour: Color
    let idx: Int
    
    var body: some View {
        
//        Text(title)
//            .multilineTextAlignment(.center)
//            .fixedSize(horizontal: false, vertical: false)
//            .foregroundColor(textColour)
//            .frame(width: width)
//            .contentShape(Rectangle())
//
        if idx == 0 {
        
            VStack {
                Text("\(title)")
                    .font(.system(size: 60, weight: .regular))
                Text("min\n(w/o baggage)")
                    .font(.system(size: 17, weight: .regular))
            }
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: false)
            .foregroundColor(textColour)
            .frame(width: width)
            .contentShape(Rectangle())
            
        } else {
            
            VStack {
                Text("\(title)")
                    .font(.system(size: 60, weight: .regular))
                Text("min\n(with baggage)")
                    .font(.system(size: 17, weight: .regular))
            }
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: false)
            .foregroundColor(textColour)
            .frame(width: width)
            .contentShape(Rectangle())
            
        }
    }
}

struct CustomSegmentedControl_Previews: PreviewProvider {
    @State static var selection = 0
    
    static var previews: some View {
        CustomSegmentedControl(selection: $selection, size: CGSize(width: 300, height: 200), segmentLabels: [23, 40])
    }
}
