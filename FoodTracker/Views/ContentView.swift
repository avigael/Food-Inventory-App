//
//  ContentView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/12/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    @State var image: UIImage = UIImage(imageLiteralResourceName: "Dark-Image")
    
    @State var showSettings: Bool = false
    @State var showSearch: Bool = false
    @State var showRemove: Bool = false
    @State var showCreate: Bool = false
    
    @State var editingItem: Item?
    
    var body: some View {
        HStack {
            // Background
            
            // Content
            ScrollView(.vertical, showsIndicators: false) {
                toolbar
                    .padding(.horizontal)
                expiringSoonItems
                allItems
                    .padding(.horizontal)
            }
        }
        .background(backgroundImage)
        .sheet(isPresented: $showSettings) {
            SettingsView(currentThreshold: vm.threhold, image: $image)
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
    private var backgroundImage: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var toolbar: some View {
        HStack {
            IconButtonView(action: $showSettings, systemName: "gearshape")
            
            NavigationLink(isActive: $showSearch) {
                SearchView(searchText: $vm.searchText)
                    .navigationTitle("Search Items")
            } label: {
                IconButtonView(action: $showSearch, systemName: "magnifyingglass")
            }
            
            Spacer()
            
            NavigationLink(isActive: $showRemove) {
                DeletionView()
                    .navigationTitle("Delete Items")
            } label: {
                IconButtonView(action: $showRemove, systemName: "minus")
            }
            
            IconButtonView(action: $showCreate, systemName: "plus")
        }
        .padding(.top)
    }
    
    private var expiringSoonItems: some View {
        VStack {
            if !vm.expiringSoon.isEmpty {
                HStack {
                    Text("Expiring Soon")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.text)
                    Spacer()
                }
                .padding(.horizontal)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    HStack {
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            ForEach(vm.expiringSoon) { item in
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
    
    private var allItems: some View {
        VStack {
            if !vm.allItems.isEmpty {
                HStack {
                    Text("All Items")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.text)
                    Spacer()
                }
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(vm.allItems) { item in
                    ItemView(item: item)
                        .onTapGesture {
                            editingItem = item
                        }
                }
            }
        }
    }
}
