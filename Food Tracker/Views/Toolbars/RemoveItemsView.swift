//
//  RemoveItemsView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct RemoveItemsView: View {
    @EnvironmentObject var store: ItemStore
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showingRemove: Bool
    @State var selectButtonToggle = true
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    store.deselectAll()
                    store.selectingOff()
                    showingRemove = false
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                            .frame(width: 50, height: 50)
                        Image(systemName: "chevron.backward").foregroundColor(colorScheme == .dark ? .lightText : .darkText)
                    }
                }
                Spacer()
                Button {
                    if selectButtonToggle {
                        store.selectAll()
                        selectButtonToggle = false
                    } else {
                        store.deselectAll()
                        selectButtonToggle = true
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                            .frame(width: (selectButtonToggle ? 100 : 125), height: 50)
                        Text(selectButtonToggle ? "Select All" : "Deselect All")
                            .foregroundColor(colorScheme == .dark ? .lightText : .darkText)
                    }
                }
                Button {
                    store.removeSelected()
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                            .frame(width: 50, height: 50)
                        Image(systemName: "trash").foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 75)
            ScrollView(showsIndicators: false) {
                AllItemsView()
            }
        }
    }
}

struct RemoveItemsView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    @State static var showingRemove = false
    static var previews: some View {
        RemoveItemsView(showingRemove: $showingRemove)
            .preferredColorScheme(.dark)
            .environmentObject(itemStore)
    }
}
