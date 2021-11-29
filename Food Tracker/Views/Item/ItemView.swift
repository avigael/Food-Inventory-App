//
//  ItemView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var store: ItemStore
    @Environment(\.colorScheme) var colorScheme
    
    @State var item: Item
    @State var showingEdit = false
    @State var showingAlert = false
    
    var body: some View {
        let daysLeft = item.daysUntilExpired()
        let backgroundColor = colorScheme == .dark ? Color.darkAccent : Color.lightAccent
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(item.isSelected ? Color.selectColor : .clear, lineWidth: 5)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill((daysLeft < 0 && !item.cantExpire) ? Color.expiredColor : backgroundColor)
                    )
                .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 0)
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        Text(String(item.quantity))
                        Spacer()
                    }
                }
                if !item.cantExpire {
                    switch daysLeft {
                    case 0:
                        Text("Almost expired!")
                    case 1..<366:
                        Text(String(daysLeft) + (daysLeft == 1 ? " Day" : " Days") + " Left")
                    case 366...:
                        Text("Over A Year Left")
                    default:
                        if daysLeft < -365 {
                            Text("Over A Year Expired")
                        } else {
                            Text(String(abs(daysLeft)) + (daysLeft == -1 ? " Day" : " Days") + " Expired")
                        }
                    }
                    Spacer()
                    Text(formatDate(item.expiration))
                        .font(.caption)
                } else {
                    Text("∞ Days Left")
                    Spacer()
                    Text("Does not expire")
                        .font(.caption)
                }
            }
            .foregroundColor(daysLeft < store.threshold && !item.cantExpire ? .expiringText : (colorScheme == .dark ? .lightText : .darkText))
            .padding()
        }
        .aspectRatio(1, contentMode: .fit)
        .contextMenu {
            Button {
                showingEdit = true
            } label: {
                Text("Edit")
                Image(systemName: "pencil")
            }
            Button(role: .destructive) {
                showingAlert = true
            } label: {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
        .onTapGesture {
            if store.selecting {
                store.isSelectedToggle(item)
            } else {
                showingEdit = true
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditView(item: item, name: item.name, quantity: item.quantity, note: item.note, cantExpire: item.cantExpire, date: item.expiration)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Delete Item?"),
                  message: Text("This action cannot be undone!"),
                  primaryButton: Alert.Button.destructive(Text("Delete")) { store.removeItem(item) },
                  secondaryButton: Alert.Button.cancel(Text("Cancel"))
            )
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

struct ItemView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    static var previews: some View {
        Group {
            ItemView(item: itemStore.items[0])
                .environmentObject(itemStore)
        }
        .previewLayout(.fixed(width: 150, height: 150))
    }
}
