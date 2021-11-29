//
//  ContentView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: ItemStore
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingSettings = false
    @State private var showingSearch = false
    @State private var showingCreate = false
    @State private var showingRemove = false
    private var showExpiring: Bool { store.checkExpiring() }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(colorScheme == .dark ? .darkMode : .lightMode)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if showingSearch {
                    SearchingView(showingSearch: $showingSearch)
                } else if showingRemove {
                    RemoveItemsView(showingRemove: $showingRemove)
                } else {
                    ToolbarView(showingSettings: $showingSettings, showingSearch: $showingSearch, showingCreate: $showingCreate, showingRemove: $showingRemove)
                    ScrollView(showsIndicators: false) {
                        if !showingSearch {
                            if showExpiring {
                                ExpiringItemsView()
                            }
                        }
                         AllItemsView()
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreate) {
            CreateView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(threshold: store.threshold)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(itemStore)
        }
    }
}
