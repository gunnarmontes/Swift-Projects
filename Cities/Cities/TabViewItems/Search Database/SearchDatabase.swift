//
//  SearchDatabase.swift
//  Cities
//
//  Created by Gunnar Motes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import SwiftData

// Global Search Parameters
var searchCategory = ""
var searchQuery = ""
var populationMin = 0
var populationMax = 0
var isCapital = true

struct SearchDatabase: View {
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    @State private var populationMinTextFieldValue = ""
    @State private var populationMaxTextFieldValue = ""
    
    //Controls isCapital variable
    @State private var toggle = false
    
    
    let searchCategories = ["City Name", "2-Letter Country Code",
                            "≤ Population ≤", "Capital City"]
    @State private var selectedCategoryIndex = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchDatabase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                //Holds search categorys
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0 ..< searchCategories.count, id: \.self) {
                            Text(searchCategories[$0])
                        }
                    }
                }
                //In case of population search category
                if selectedCategoryIndex == 2 {
                    Section(header: Text("≤ Population ≤"), footer: Text("Return on keyboard after entering value.").italic()) {
                        HStack {
                            TextField("Enter minimum population", text: $populationMinTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Int(populationMinTextFieldValue) {
                                        populationMin = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Population!"
                                        alertMessage = "Entered population value \(populationMinTextFieldValue) is not an integer number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                populationMinTextFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                        HStack {
                            TextField("Enter maximum population", text: $populationMaxTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Int(populationMaxTextFieldValue) {
                                        populationMax = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Population!"
                                        alertMessage = "Entered population value \(populationMaxTextFieldValue) is not an integer number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                populationMaxTextFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                
                } else if (selectedCategoryIndex == 3)
                {
                    Section(header: Text("Search Capital City"))
                    {
                        Toggle("Show Capital City", isOn: $toggle)
                    }
                    
                }
                else {
                    Section(header: Text("Search \(searchCategories[selectedCategoryIndex])")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            
                            // Button to clear the text field
                            Button(action: {
                                searchFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                }
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                //toggles global variable
                                isCapital = toggle
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                }
                if searchCompleted {
                    Section(header: Text("List Cities Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Countries Found")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchCategory = ""
                                searchQuery = ""
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                           
                            Spacer()
                        }
                    }
                     
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        
        searchCategory = searchCategories[selectedCategoryIndex]
        
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        
        return AnyView(DBSearchResultsList())
    }
    
    
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {

        switch selectedCategoryIndex {
        case 0,1:
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (queryTrimmed.isEmpty) {
                alertTitle = "Empty Query"
                alertMessage = "Please enter a search query!"
                return false
            }
            searchQuery = queryTrimmed
            
        case 2:
            if (populationMin == 0 || populationMax == 0) {
                alertTitle = "Missing Population"
                alertMessage = "Please enter valid values for minimum and maximum population!"
                return false
            }
            if (populationMax < populationMin) {
                alertTitle = "Unrecognized Range"
                alertMessage = "Maximum population must be greater than minimum population!"
                return false
            }
            
        default:
            print("Selected Index is out of range")
        }
        
        return true
    }
    
}


#Preview {
    SearchDatabase()
}
