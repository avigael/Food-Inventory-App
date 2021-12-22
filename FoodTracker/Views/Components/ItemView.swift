//
//  ItemView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/14/21.
//

import SwiftUI
import Combine

struct ItemView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    @AppStorage("threshold") var threshold = 5
    
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(item.title).fontWeight(.bold)
                Spacer()
                Text("\(item.quantity.as2DecimalString())").font(.caption)
            }
            Spacer()
            if let daysLeft = item.daysUntilExpired() {
                if daysLeft < 0 {
                    Text(String(abs(daysLeft)) + (daysLeft == -1 ? " Day" : " Days") + " Expired")
                } else {
                    Text(String(daysLeft) + (daysLeft == 1 ? " Day" : " Days") + " Left")
                }
            } else {
                Text("∞ Days Left")
            }
            Text(formatDate(item.expirationDate))
        }
        .foregroundColor(item.daysUntilExpired() ?? threshold + 1 <= threshold && item.expirationDate != nil ? Color.theme.expiredText : Color.theme.text)
        .padding()
        .background(item.daysUntilExpired() ?? 1 < 0 ? Color.red.opacity(0.25) : Color.clear, in: RoundedRectangle(cornerRadius: 15))
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ItemView(item: sample.item.expired)
                .previewLayout(.fixed(width: 175, height: 175))
                .environmentObject(sample.vm)
            ItemView(item: sample.item.expired)
                .previewLayout(.fixed(width: 175, height: 175))
                .preferredColorScheme(.dark)
                .environmentObject(sample.vm)
        }
    }
}

extension ItemView {
    /// Converts  an Optional Date into a String
    /// ```
    /// Converts Date(...) to "11/22/33"
    /// Converts nil to "Does not expire"
    /// ```
    /// - Parameter date: Date Struct. A specific point in time
    /// - Returns: Date as a String
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "en_US")
            return formatter.string(from: date)
        }
        return "Does not expire"
    }
}
