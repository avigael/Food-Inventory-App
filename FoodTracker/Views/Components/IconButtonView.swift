//
//  IconButtonView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/14/21.
//

import SwiftUI

struct IconButtonView: View {
    
    @Binding var action: Bool
    let systemName: String
    
    var body: some View {
        Button(action: {action.toggle()}) {
            Image(systemName: systemName)
                .foregroundColor(Color.theme.text)
                .padding()
        }
        .frame(width: 50, height: 50)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
    }
}

struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IconButtonView(action: .constant(false), systemName: "plus")
                .previewLayout(.sizeThatFits)
            IconButtonView(action: .constant(true), systemName: "xmark")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
