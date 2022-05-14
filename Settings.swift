//
//  Settings.swift
//  BackToSleep
//
//  Created by Wiel-Berggren, Gustav on 2022-04-21.
//

import SwiftUI
import AVKit

struct Settings: View {
    @Environment(\.presentationMode) var presentationMode
    @State var audioPlayer: AVAudioPlayer!
    @State private var shadowLow = false
    @State private var shadowHigh = false
    @Binding var volumeHigh: Double
    @Binding var volumeLow: Double
    @Binding var duration: Double
    @Binding var madeSettings: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var shadowCount = 12
    @State private var shadowCountOn = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                VStack(alignment:.leading){
                    Text("\(volumeLow*100, specifier: "%.0f")%")
                        .foregroundColor(Color("Bakgrund"))
                        .font(.system(size: 50.0))
                        .padding([.top, .leading], 25.0)
                        
                    Text("SET WHITE NOISE BASE VOLUME")
                        .foregroundColor(Color("Bakgrund"))
                        .font(.system(size: 14.0))
                        .padding(.leading, 25.0)
                        .opacity(0.4)
                        
                    Slider(value: $volumeLow, in: 0...1, step: 0.05)
                        .padding([.leading, .bottom, .trailing], 25.0)
                        .accentColor(Color("Bakgrund"))
                
                    }
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Aprikos"), Color("Lila")]), startPoint: .top, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: shadowLow ? .white : .black, radius: shadowLow ? 20 : 0)
                
                VStack(alignment:.leading){
                    Text("\(volumeHigh*100, specifier: "%.0f")%")
                        .foregroundColor(Color("Bakgrund"))
                        .font(.system(size: 50.0))
                        .padding([.top, .leading], 25.0)
                        
                    Text("SET WHITE NOISE HIGH VOLUME")
                        .foregroundColor(Color("Bakgrund"))
                        .font(.system(size: 14.0))
                        .padding(.leading, 25.0)
                        .opacity(0.4)
                        
                    Slider(value: $volumeHigh, in: 0...1, step: 0.05)
                        .padding([.leading, .bottom, .trailing], 25.0)
                        .accentColor(Color("Bakgrund"))
                
                }
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Lax"), Color("Lila")]), startPoint: .top, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .padding()
                .shadow(color: shadowHigh ? .white : .black, radius: shadowHigh ? 20 : 0)
                
                VStack(alignment:.leading){
                    Text("\(duration/60, specifier: "%.0f") mins")
                        .foregroundColor(Color("Bakgrund"))
                        .font(.system(size: 50.0))
                        .padding([.top, .leading], 25.0)
                        
                    Text("SET DURATION FOR VOLUME INCREASE")
                        .foregroundColor(Color("Bakgrund"))
                        .font(.system(size: 14.0))
                        .padding(.leading, 25.0)
                        .opacity(0.4)
                        
                    Slider(value: $duration, in: 60...600, step: 60)
                        .padding([.leading, .bottom, .trailing], 25.0)
                        .accentColor(Color("Bakgrund"))
                
                }
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Lila"), Color("Blue")]), startPoint: .top, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .padding()
            
                HStack {
                    
                    Button {
                        shadowCount = 12
                        shadowCountOn = true
                    } label: {
                        Label("Test volume", systemImage: "speaker.wave.2.circle.fill")
                            .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                            .onReceive(timer) { _ in
                                if shadowCount > 6 && shadowCountOn {
                                    shadowCount -= 1
                                    shadowLow = true
                                    audioPlayer.setVolume(Float((volumeLow)), fadeDuration: 1)
                                    audioPlayer.play()
                                }
                                if shadowCount < 7 && shadowCountOn {
                                    shadowCount -= 1
                                    shadowLow = false
                                    shadowHigh = true
                                    audioPlayer.setVolume(Float((volumeHigh)), fadeDuration: 1)
                                    audioPlayer.play()
                                }
                                if shadowCount == 0 {
                                    shadowCountOn = false
                                    shadowLow = false
                                    shadowHigh = false
                                    audioPlayer.pause()
                                }
                            }
                        }
                    .padding()
                    .foregroundColor(Color("Bakgrund"))
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Lila"), Color("Blue")]), startPoint: .top, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    
                    Spacer()
                    
                    Button {
                        madeSettings = true
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Start", systemImage: "zzz")
                    }
                    .padding()
                    .foregroundColor(Color("Bakgrund"))
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Lila"), Color("Blue")]), startPoint: .top, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                    
                }
                .padding()
            }

            }
            
        .onAppear {
                    let sound = Bundle.main.path(forResource: "brown-noise", ofType: "mp3")
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    self.audioPlayer.numberOfLoops = -1
                    
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(volumeHigh: .constant(0.5), volumeLow: .constant(0.2), duration: .constant(180), madeSettings: .constant(false))
    }
}
