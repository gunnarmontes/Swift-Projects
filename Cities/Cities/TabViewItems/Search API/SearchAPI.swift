//
//  SearchAPI.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//


import SwiftUI

struct SearchAPI: View {
    
   
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchAPI")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
               
                Section(header: Text("Enter a City Name To Search")) {
                    HStack {
                        TextField("Enter Search Query", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            searchFieldValue = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                
                Section(header: Text("Search Cities")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }   // End of HStack
                }
                
                if searchCompleted {
                    Section(header: Text("Show City Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show City Found")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
                
            }   // End of Form
            .navigationTitle("Search Any City in the World")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
        
    }   // End of body var
    
    /*
     ----------------
     MARK: Search API
     ----------------
     */
    func searchApi() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /*
         Since URLs cannot have spaces, replace space in query with
         Unicode Transformation Format 8-bit (UTF-8) encoding of space as %20
         Example: South Africa --> South%20Africa
         NOTE: This API uses %20 for space; other APIs may use + instead.
         */
        let queryCleaned = queryTrimmed.replacingOccurrences(of: " ", with: "%20")
        
        // Convert the query to lowercase
        let searchQuery = queryCleaned.lowercased()
        
        // Public function getFoundCountriesFromApi is given in CountryApiData.swift
        getFoundCitiesFromApi(query: searchQuery)
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array foundCountriesList is given in CountryApiData.swift
        if foundCitiesList.isEmpty {
            return AnyView(
                NotFound(message: "No Cities Found!\n\nThe entered query \(searchFieldValue) did not return any city from the API! Please enter another search query.")
            )
        }
        
        return AnyView(APISearchResultsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
    
}


#Preview {
    SearchAPI()
}
