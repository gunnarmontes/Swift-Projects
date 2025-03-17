//
//  APISearchResultsList.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//


import SwiftUI

struct APISearchResultsList: View {
    var body: some View {
        List {
            // 'id' can be specified as either 'self' or a unique attribute such as 'cca3'
            ForEach(foundCitiesList, id: \.name) { aCityStruct in
                NavigationLink(destination: APISearchResultDetails(cityStruct: aCityStruct)) {
                    APISearchResultItem(cityStruct: aCityStruct)
                }
            }
        }
        .navigationTitle("API Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    APISearchResultsList()
}
