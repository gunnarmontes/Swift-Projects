//
//  ContentView.swift
//  Cities
//
//  Created by Gunnar Montes on 2/27/25.
//

import SwiftUI

struct ContentView: View {
   

    var body: some View {
        TabView {
            Tab("Home",
                systemImage: "house")
            {
                Home()
            }
            Tab("Favorites",
                systemImage: "star")
            {
                FavoritesList()
            }
            Tab("Search DB",
                systemImage: "magnifyingglass")
            {
                SearchDatabase()
            }
            Tab("Search API",
                systemImage: "magnifyingglass.circle.fill")
            {
                SearchAPI()
            }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }// end tabView
        .tabViewStyle(.sidebarAdaptable)
        
            
        
        
    }
}


