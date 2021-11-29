//
//  ToolbarView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var store: ItemStore
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showingSettings: Bool
    @Binding var showingSearch: Bool
    @Binding var showingCreate: Bool
    @Binding var showingRemove: Bool
    
    var body: some View {
        HStack {
            HStack {
                settingsButton
                searchButton
                Spacer()
                removeButton
                createButton
            }
            .padding(.horizontal)
        }
        .frame(height: 75)
    }
    
    var settingsButton: some View {
        Button {
            showingSettings = true
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                    .frame(width: 50, height: 50)
                Image(systemName: "gearshape")
                    .foregroundColor(colorScheme == .dark ? .lightText : .darkText)
            }
        }
    }
    
    var searchButton: some View {
        Button {
            showingSearch = true
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                    .frame(width: 50, height: 50)
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colorScheme == .dark ? .lightText : .darkText)
            }
        }
    }
    
    var removeButton: some View {
        Button {
            showingRemove = true
            store.selectingOn()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                    .frame(width: 50, height: 50)
                Image(systemName: "minus")
                    .foregroundColor(colorScheme == .dark ? .lightText : .darkText)
            }
        }
    }
    
    var createButton: some View {
        Button {
            showingCreate = true
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                    .frame(width: 50, height: 50)
                Image(systemName: "plus")
                    .foregroundColor(colorScheme == .dark ? .lightText : .darkText)
            }
        }
    }
}

struct ToolbarView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    @State static var showingSettings = false
    @State static var showingSearch = false
    @State static var showingCreate = false
    @State static var showingRemove = false
    
    static var previews: some View {
        Group {
            ToolbarView(showingSettings: $showingSettings, showingSearch: $showingSearch, showingCreate: $showingCreate, showingRemove: $showingRemove)
                .environmentObject(itemStore)
                .previewLayout(.sizeThatFits)
            ToolbarView(showingSettings: $showingSettings, showingSearch: $showingSearch, showingCreate: $showingCreate, showingRemove: $showingRemove)
                .environmentObject(itemStore)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
