//
//  DatabaseCreation.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import SwiftData

public func createCitiesDatabase() {
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
    
    // Create the context (workspace) where Country objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let fetchDescriptor = FetchDescriptor<City>()
    
    var listOfAllCitiesInDatabase = [City]()
    
    do {
        // Obtain all of the Country objects from the database
        listOfAllCitiesInDatabase = try modelContext.fetch(fetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }
    
    if !listOfAllCitiesInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content in DatabaseInitialContent.json   |
     ----------------------------------------------------------
     */
    
    var cityStructList = [CityStruct]()
    
    //DecodejsonFileIntoArrayOfStructs in UtilityFunctions file
    
    cityStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DatabaseInitialContent.json", fileLocation: "Main Bundle")
    
    for aCity in cityStructList {
        
        //Instantiate new country objects
        /*
         Sample struct
         {
             "name": "San Francisco",
             "latitude": 37.7562,
             "longitude": -122.443,
             "country": "US",
             "population": 3592294,
             "region": "California",
             "is_capital": false
         }
         */
        
        let newCity = City(
            
            name: aCity.name,
            latitude: aCity.latitude,
            longitude: aCity.longitude,
            country: aCity.country,
            population: aCity.population,
            region: aCity.region,
            is_capital: aCity.is_capital
            
            
        )
        //New city added to database
        modelContext.insert(newCity)
    }// end of loop
    /*
     =================================
     |   Save All Database Changes   |
     =================================
     
     🔴 NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    print("Database is successfully created!")
}
