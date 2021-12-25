//
//  ContentView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/12/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    
    @AppStorage("allowNotifications") private var allowNotifications = false
    
    @State private var showSettings: Bool = false
    @State private var showSearch: Bool = false
    @State private var showRemove: Bool = false
    @State private var showCreate: Bool = false
    @State private var editingItem: Item?
    
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: false) {
                toolbar
                    .padding(.horizontal)
                if vm.allItems.isEmpty {
                    emptyMessage
                }
                expiringSoonItems
                allItems
                    .padding(.horizontal)
            }
        }
        .background(backgroundImage)
        .sheet(isPresented: $showSettings) {
            SettingsView(image: vm.backgroundImage, currentThreshold: vm.threhold, notificationToggle: allowNotifications)
        }
        .sheet(item: $editingItem) { item in
            EditItemView(item: item)
        }
        .sheet(isPresented: $showCreate) {
            AddItemView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(sample.vm)
    }
}

extension ContentView {
    
    /// Background image of application
    private var backgroundImage: some View {
        Image(uiImage: vm.backgroundImage)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    /// Top row of buttons
    private var toolbar: some View {
        HStack {
            // Settings Button
            IconButtonView(action: $showSettings, systemName: "gearshape")
            // Search Button
            NavigationLink(isActive: $showSearch) {
                SearchView(searchText: $vm.searchText)
                    .navigationTitle("Search Items")
            } label: {
                IconButtonView(action: $showSearch, systemName: "magnifyingglass")
            }
            Spacer()
            // Delete Items Button
            NavigationLink(isActive: $showRemove) {
                DeletionView()
                    .navigationTitle("Delete Items")
            } label: {
                IconButtonView(action: $showRemove, systemName: "minus")
            }
            // Create Item Button
            IconButtonView(action: $showCreate, systemName: "plus")
        }
        .padding(.top)
    }
    
    private var emptyMessage: some View {
        VStack {
            Text("No Items")
                .font(.title)
                .fontWeight(.bold)
            Text("Tap + to Add an Item")
                .fontWeight(.bold)
        }
        .foregroundColor(Color.theme.text)
        .shadow(color: Color.theme.shadow, radius: 3, x: 0, y: 0)
        .padding(.vertical)
    }
    
    /// Horizontally scrolling list of items below threshold
    private var expiringSoonItems: some View {
        VStack {
            // Title (Do not show if no items exist)
            if !vm.expiringSoon.isEmpty {
                HStack {
                    Text("Expiring Soon")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.text)
                        .shadow(color: Color.theme.shadow, radius: 3, x: 0, y: 0)
                    Spacer()
                }
                .padding(.horizontal)
            }
            // Content
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    HStack {
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            ForEach(vm.expiringSoon) { item in
                                // Tap an item to edit it
                                ItemView(item: item)
                                    .onTapGesture {
                                        editingItem = item
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .frame(height: vm.expiringSoon.isEmpty ? 0 : (UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.height / 5 : UIScreen.main.bounds.width / 5))
        }
    }
    
    /// Vertical list of all items
    private var allItems: some View {
        VStack {
            // Title (Do not show if no items exist)
            if !vm.allItems.isEmpty {
                HStack {
                    Text("All Items")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.text)
                        .shadow(color: Color.theme.shadow, radius: 3, x: 0, y: 0)

                    Spacer()
                }
            }
            // Content
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(vm.allItems) { item in
                    // Tap an item to edit it
                    ItemView(item: item)
                        .onTapGesture {
                            editingItem = item
                        }
                }
            }
        }
    }
}
