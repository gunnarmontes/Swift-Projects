//  CountryName.swift
//  Cities
//
//  Created by Osman Balci on 2/12/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//
 
import SwiftUI
 
struct CountryName: View {
   
    // Input Parameter
    // Country Code Alpha 2 (cca2): 2-letter country code
    let cca2: String
   
    var body: some View {
       
        // Create an instance of locale struct
        let locale = Locale(identifier: Locale.current.identifier)
       
        // Obtain country name from its 2-letter country code
        let nameOfCountry = locale.localizedString(forRegionCode: cca2) ?? ""
       
        /*
         ?? is the Nil-Coalescing Operator used for Optional processing
         IF (country name can be obtained from given cca2) THEN
             store obtained name into nameOfCountry
         ELSE
             store "" into nameOfCountry
         */
       
        Text(nameOfCountry)
    }
}
