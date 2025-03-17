//
//  Home.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI

fileprivate let imageNames = ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7", "photo8", "photo9"]
fileprivate let numberOfImages = 9
fileprivate let imageCaptions = ["Barcelona, Spain", "Istanbul, Türkiye", "Tokyo, Japan", "Paris, France", "Sydney, Australia", "London, United Kingdom", "Munich, Germany", "Amsterdam, The Netherlands", "Rome, Italy"]
struct Home: View {
    
    @State var index = 0
    
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("Welcome")
                    .padding()
                
                Image(imageNames[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .padding()
                
                // Subscribe to the timer publisher
                    .onReceive(timer) { _ in
                        index += 1
                        if index > numberOfImages - 1 {
                            index = 0
                        }
                    }
                
                Text(imageCaptions[index])
                    .font(.system(size: 14, weight: .light, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                Text("Powered By")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                // Show REST Countries API website externally in default web browser
                Link(destination: URL(string: "https://www.api-ninjas.com/api/city")!) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.large)
                        Text("City API")
                    }
                }
                .padding()
            } //End of VStack
            
        } // End of ScrollView
        .onAppear() {
            startTimer()
        }
        .onDisappear() {
            stopTimer()
        }
        
    } // end of body
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
}

#Preview {
    Home()
}
