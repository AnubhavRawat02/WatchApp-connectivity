//
//  ContentView.swift
//  WatchApp1
//
//  Created by Anubhav Rawat on 21/10/23.
//

import SwiftUI
import WatchConnectivity

class ViewModel: ObservableObject{
//    @Published var isSupported: Bool = false  //Returns a Boolean value indicating whether the current iOS device is able to use a session object.
    
    @Published var isPaired: Bool = false  //A Boolean indicating whether the current iPhone has a paired Apple Watch.
    
//    @Published var iosDeviceNeedsUnlocked: Bool = false //A Boolean value indicating whether the paired iPhone must be in an unlocked state to be reachable.
    
    @Published var isWatchAppInstalled: Bool = false  //A Boolean value indicating whether the currently paired and active Apple Watch has installed the app.
    
//    @Published var isCompanionAppInstalled: Bool = false //A Boolean value indicating whether the companion has installed the app.
    
    @Published var isComplicationEnabled: Bool = false //A Boolean value indicating whether the Watch app’s complication is in use on the currently paired and active Apple Watch.
    
    @Published var isReachable: Bool = false  //A Boolean value indicating whether the counterpart app is available for live messaging.
    
    
//    @Published var applicationContextSent: [String: Any] = [:]
//    
//    @Published var applicationContextReceived: [String: Any] = [:]
    
    @Published var applicationContextSent: String = ""
    
    @Published var applicationContextReceived: String = ""
    
    @Published var outstandingUserInfoTransfers: [WCSessionUserInfoTransfer] = []
    
    
    
}

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    @State var text: String = ""
    @FocusState var keyboardOpen: Bool
    
    var viewModel = WatchConnectivityController()
    
    func reloadMetadata(){
        vm.isPaired = viewModel.session.isPaired
        
        vm.isWatchAppInstalled = viewModel.session.isWatchAppInstalled
        
        vm.isComplicationEnabled = viewModel.session.isComplicationEnabled
        
        vm.isReachable = viewModel.session.isReachable
        
        if let contextMessageSent = viewModel.session.applicationContext["message"] as? String{
            vm.applicationContextSent = contextMessageSent
        }
        
        if let contextMessageReceived = viewModel.session.receivedApplicationContext["message"] as? String{
            vm.applicationContextReceived = contextMessageReceived
        }
        
        vm.outstandingUserInfoTransfers = viewModel.session.outstandingUserInfoTransfers
    }
    
    var body: some View {
        ScrollView{
            VStack {
//                vm.outstandingUserInfoTransfers[0].isTransferring
                TextField("enter text to be sent.", text: $text)
                    .focused($keyboardOpen)
                
                buttons
                
                metaDataa
                
            }
            .padding()
            .onAppear(perform: {
                reloadMetadata()
                
            })
        }
        
    }
    
    
    
    @ViewBuilder
    var metaDataa: some View{
        VStack(spacing: 10){
            Text("METADATA")
                .font(.system(size: 30))
                .fontWeight(.black)
            
            Text("isPaired to the apple watch : \(vm.isPaired.description)")
            
            Text("is watch app installed: \(vm.isWatchAppInstalled.description)")
            
            Text("is complication enabled: \(vm.isComplicationEnabled.description)")
            
            Text("is reachable live : \(vm.isReachable.description)")
            
            Text("application context sent message \(vm.applicationContextSent)")
            
            Text("application context received message \(vm.applicationContextReceived)")
            
            VStack(spacing: 3){
                Text("user info transfer:")
                ForEach(vm.outstandingUserInfoTransfers, id: \.self){transfer in
                    HStack{
                        Text("\(transfer.userInfo["message"] as? String ?? "no message")")
                        Text("\(transfer.isTransferring.description)")
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    var buttons: some View{
        VStack{
            
//            reload metadata
            Button {
                reloadMetadata()
                keyboardOpen = false
            } label: {
                Text("reload Metadata")
            }
            .buttonStyle(CustomButton())

//            update the application context.
            Button {
                if viewModel.session.activationState == .activated{
                    Task{
                        do{
                            try viewModel.session.updateApplicationContext(["message": "\(text)"])
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }else{
                    print("session not activated")
                }
                
                keyboardOpen = false
                
            } label: {
                Text("update Context")
            }.buttonStyle(CustomButton())

            
//            send immediate message.
            Button {
                
                if viewModel.session.isReachable{
                    viewModel.session.sendMessage(["message": "\(text)"]) { reply in
                        print("reply from the message")
                        print(reply)
                    } errorHandler: { error in
                        print("some error while sending message. ")
                        print(error)
                    }
                }else{
                    print("app not opened on watch.")
                }
                
                keyboardOpen = false
                

            } label: {
                Text("send immediate message")
            }.buttonStyle(CustomButton())

//            transfer user info in the background.
            Button {
                viewModel.session.transferUserInfo(["message": "\(text)"])
                keyboardOpen = false
            } label: {
                Text("Transfer user data in background")
            }
            .buttonStyle(CustomButton())

            
        }
    }
    
    
}


struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0.5, green: 0.5, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
#Preview {
    ContentView()
}
