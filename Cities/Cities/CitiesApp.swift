/*
**********************************************************
*   Statement of Compliance with the Stated Honor Code   *
**********************************************************
I hereby declare on my honor and I affirm that
 
 (1) I have not given or received any unauthorized help on this assignment, and
 (2) All work is my own in this assignment.
 
I am hereby writing my name as my signature to declare that the above statements are true:
   
      Gunnar James Montes
 
**********************************************************
 */

//
//  CitiesApp.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 2/27/25.
//

import SwiftUI
import SwiftData

@main
struct CitiesApp: App {
   
    init() {
        /*
         --------------------------------------------------------
         |   Create Cities Database upon App Launch          |
         |   IF the app is being launched for the first time.   |
         --------------------------------------------------------
         */
        createCitiesDatabase()       // In DatabaseCreation.swift
    }
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
            
                /*
                 Inject the Model Container into the environment so that you can access its Model Context
                 in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
                 */
                .modelContainer(for: [City.self], isUndoEnabled: true)
        }
    }
}
