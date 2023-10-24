//
//  ContentView.swift
//  WatchApp1Watch Watch App
//
//  Created by Anubhav Rawat on 21/10/23.
//



import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = WachConnectivityForWatch()
    
    var body: some View {
        
        ScrollView{
            VStack {
                Text(" instant message : \(viewModel.message)")
                
                Text("context message: \(viewModel.contextMessage)")
                
                Text("user info message: \(viewModel.userInfoString)")
                
                Text("receivedContext: \(viewModel.receivedApplicationContextMessage)")
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
