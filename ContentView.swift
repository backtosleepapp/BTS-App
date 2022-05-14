//
//  ContentView.swift
//  BackToSleep
//
//  Created by Wiel-Berggren, Gustav on 2022-04-21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var isPresented = false
    @State private var opacity = 1.0
    @State var audioPlayer: AVAudioPlayer!
    @State private var volumeLow: Double = 0.2
    @State private var volumeHigh: Double = 0.5
    @State private var countDownTimer: Double = 300
    @State private var duration: Double = 300
    @State var timerRunning = false
    @State var madeSettings = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    if madeSettings == true {
                        Button {
                        self.audioPlayer.play()
                        UIApplication.shared.isIdleTimerDisabled = true
                    } label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.system(size: 20.0, weight: .bold))
                            .opacity(0.4)
                    }
                    Button {
                        self.audioPlayer.pause()
                        timerRunning = false
                        countDownTimer = duration
                        UIApplication.shared.isIdleTimerDisabled = false
                    } label: {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.system(size: 20.0, weight: .bold))
                            .opacity(0.4)
                    }
                    }
                    Button {
                        madeSettings = false
                        isPresented = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.system(size: 20.0, weight: .bold))
                            .opacity(0.4)
                    }
                }
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                if madeSettings == true {
                    Button {
                        self.audioPlayer.setVolume(Float((volumeHigh)), fadeDuration: 5)
                        timerRunning = true
                    } label: {
                        Text("We're up and running.\nTap screen to increase \nvolume for \(duration/60, specifier: "%.0f") minutes.")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 46, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [Color("Lax"), Color("Lila")]), startPoint: .top, endPoint: .bottomTrailing
                                )
                            )
                            .opacity(opacity)
                            .onReceive(timer) { _ in
                                if countDownTimer > 0 && timerRunning {
                                    countDownTimer -= 1
                                } else {
                                        timerRunning = false
                                        countDownTimer = duration
                                    audioPlayer.setVolume(Float((volumeLow)), fadeDuration: 5)
                                }
                            }
                            .onAppear {
                                withAnimation(.easeOut(duration: 3.0).delay(3)) {
                                    self.opacity = 0.15
                                    let sound = Bundle.main.path(forResource: "brown-noise", ofType: "mp3")
                                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                                    self.audioPlayer.numberOfLoops = -1
                                    self.audioPlayer.setVolume(Float((volumeLow)), fadeDuration: 3)
                                    self.audioPlayer.play()
                                }
                            }
                        }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Welcome to \nBackToSleep.\n\nConnect charger\nand tap settings\nto start.")
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 46, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color("Lax"), Color("Lila")]), startPoint: .top, endPoint: .bottomTrailing
                        
                                )
                            )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                }
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            Settings(volumeHigh: $volumeHigh, volumeLow: $volumeLow, duration: $duration, madeSettings: $madeSettings)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
