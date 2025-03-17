//
//  DatabaseSearch.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import SwiftData

// Global variable to hold database search results
var databaseSearchResults = [City]()

public func conductDatabaseSearch() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage Country objects
        modelContainer = try ModelContainer(for: City.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to hold the database search results
    databaseSearchResults = [City]()
    
    // Declare searchPredicate as a local variable
    var searchPredicate: Predicate<City>?
    
    //-------------------------------------------
    // 1️⃣ Define the Search Criterion (Predicate)
    //-------------------------------------------
    
    switch searchCategory {
    case "City Name":
        searchPredicate = #Predicate<City> {
            $0.name.localizedStandardContains(searchQuery)
        }

    case "2-Letter Country Code":
        searchPredicate = #Predicate<City> {
            $0.country.localizedStandardContains(searchQuery)
        }

        
    case "≤ Population ≤":
        searchPredicate = #Predicate<City> {
            $0.population >= populationMin &&
            $0.population <= populationMax
        }
    case "Capital City":
        searchPredicate = #Predicate<City> {
            $0.is_capital == isCapital
        }
        
    default:
        fatalError("Search category is out of range!")
    }
    
    //-------------------------------
    // 2️⃣ Define the Fetch Descriptor
    //-------------------------------
    
    let fetchDescriptor = FetchDescriptor<City>(
        predicate: searchPredicate,
        sortBy: [SortDescriptor(\City.name, order: .forward)]
    )
    
    //-----------------------------
    // 3️⃣ Execute the Fetch Request
    //-----------------------------
    
    do {
        databaseSearchResults = try modelContext.fetch(fetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database!")
    }
    
    //-------------------------------
    // Reset Global Search Parameters
    //-------------------------------
    searchCategory = ""
    searchQuery = ""
    populationMin = 0
    populationMax = 0

    
}

