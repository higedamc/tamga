//
//  SettingsView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import LocalAuthentication
import ConfettiSwiftUI
import BetterSafariView


struct SettingsView: View {
    
    @EnvironmentObject var session: SessionManager
    @ObservedObject var userSettings = UserSettings.shared
    @State private var counter = 0
    @State var showSafari = false
    
    var body: some View {
        NavigationView{
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10){
                    
                    List{
                        Section{
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "key")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                NavigationLink("Keys", destination: KeysView())
                            }
                            
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                NavigationLink("Relays", destination: RelaysView())
                            }

                        }
                        
                        Section{
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "square.split.bottomrightquarter.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                NavigationLink("App Icon", destination: AppIconView())
                            }
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "water.waves")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Toggle("Enable Haptics", isOn: $userSettings.hapticsEnabled)
                            }
//                            HStack(alignment: .center, spacing: 8) {
//                                Image(systemName: "faceid")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                                    .foregroundColor(.gray)
//                                Toggle("Face ID", isOn: .constant(false))
//                                    .foregroundColor(.gray)
//                            }
                        }
                        
                        Section{
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                NavigationLink("About", destination: AboutView())
                            }
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Button(action: {
                                    self.showSafari = true
                                }) {
                                    Text("Nostr Help")
                                }
                                .safariView(isPresented: $showSafari) {
                                    SafariView(
                                        url: URL(string: userSettings.moreNostrInfo)!,
                                        configuration: SafariView.Configuration(
                                            entersReaderIfAvailable: false,
                                            barCollapsingEnabled: true
                                        )
                                    )
                                    .preferredBarAccentColor(.clear)
                                    .preferredControlAccentColor(.accentColor)
                                    .dismissButtonStyle(.done)
                                }
                            }

                        }
                        
                        Section(){
                            Button("Logout", role: .destructive){
                                print("Settings => LOGOUT")
                                session.signOut()
                                AppCoreData.shared.deleteAllData()
                                HapticsManager.shared.hapticNotify(.warning)
                            }
                            Button("Reset", role: .destructive){
                                print("Settings => RESET")
                                counter += 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    session.resetOnboarding()
                                    AppCoreData.shared.deleteAllData()
                                    HapticsManager.shared.hapticNotify(.warning)
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(GroupedListStyle())
            .confettiCannon(counter: $counter, num:1, confettis: [.text("😭"), .text("😔"), .text("👋")], confettiSize: 30, repetitions: 100, repetitionInterval: 0.1)
            
        }
    }

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
                .environmentObject(SessionManager())
        }
    }
}
