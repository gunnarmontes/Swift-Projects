//
//  DBSearchResultList.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI

struct DBSearchResultsList: View {
    var body: some View {
        List {
            //Displays each country in list form
            ForEach(databaseSearchResults) { aFoundCity in
                NavigationLink(destination: FavoriteDetails(city: aFoundCity)) {
                    FavoriteItem(city: aFoundCity)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    DBSearchResultsList()
}
