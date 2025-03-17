//
//  FavoritesList.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import SwiftData

struct FavoritesList: View {
    
    /*
     @Environment property wrapper is used to obtain the modelContext object reference
     injected into the environment in CountriesApp.swift via .modelContainer.
     modelContext is the workspace where database objects are managed by using
     modelContext.insert(), modelContext.delete() or modelContext.save().
     */
    @Environment(\.modelContext) private var modelContext

    // Obtain all countries in the database as sorted alphabetically w.r.t. country commonName
    @Query(FetchDescriptor<City>(sortBy: [SortDescriptor(\City.name, order: .forward)])) private var listOfAllCitiessInDatabase: [City]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    // Search Bar: 1 of 4 --> searchText contains the search query entered by the user
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                /*
                 ForEach requires a unique id for each list item to be able to dynamically list them as scrollable.
                 Every database object is internally assigned a unique object id. Therefore, when listing database
                 objects with ForEach, we do not specify an id since the internally assigned id is used by default.
                 */
                
                // Search Bar: 2 of 4 --> Use filteredCountries
                ForEach(filteredCities) { aCity in
                    NavigationLink(destination: FavoriteDetails(city: aCity)) {
                        FavoriteItem(city: aCity)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the country?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                    'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                     element to be deleted. It is nil if the array is empty. Process it as an optional.
                                    */
                                    if let index = toBeDeleted?.first {
                                        let cityToDelete = listOfAllCitiessInDatabase[index]
                                        modelContext.delete(cityToDelete)
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }   // End of alert
                    }   // End of NavigationLink
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }// end of list
            .navigationTitle("Favorites")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            
            
        } //end of navStack
        // Search Bar: 3 of 4 --> Attach 'searchable' modifier to the NavigationStack
        .searchable(text: $searchText, prompt: "Search a Favorite Country")
    }
    
    // Search Bar: 4 of 4 --> Compute filtered results
    var filteredCities: [City] {
        if searchText.isEmpty {
            listOfAllCitiessInDatabase
        } else {
            listOfAllCitiessInDatabase.filter {
                $0.name.localizedStandardContains(searchText)
            }
        }
    }
    private func delete(offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }
}

#Preview {
    FavoritesList()
}
