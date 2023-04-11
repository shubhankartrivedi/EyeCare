//
//  ContentView.swift
//  EyeCare
//
//  Created by Shubhankar Trivedi on 12/04/23.
//

import SwiftUI


struct ContentView: View {
    @State private var timeRemaining = 60
    @State private var isTimerRunning = false
    @State private var restInterval = 60
    
    var body: some View {
        VStack {
            Text("Rest your eyes!")
                .font(.title)
            
            // Show the TimerView, which contains the progress bar
            TimerView(timeRemaining: $timeRemaining, isTimerRunning: $isTimerRunning, restInterval: restInterval)
                .padding(.vertical)
            
            Button(isTimerRunning ? "Stop" : "Start") {
                isTimerRunning.toggle()
                
                
                if isTimerRunning {
                    // Start the timer
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            // Time's up, reset the timer
                            timeRemaining = restInterval
                            isTimerRunning = false
                            timer.invalidate()
                        }
                    }
                } else {
                    // Stop the timer
                    isTimerRunning.toggle()
                    timeRemaining = restInterval
                }
            }
            
            Picker("Rest Interval", selection: $restInterval) {
                Text("30 seconds").tag(30)
                Text("60 seconds").tag(60)
                Text("90 seconds").tag(90)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
    }
}
struct TimerView: View {
    @Binding var timeRemaining: Int
    @Binding var isTimerRunning: Bool
    let restInterval: Int
    
    var body: some View {
        ProgressView(value: Double(restInterval - timeRemaining), total: Double(restInterval))
            .onChange(of: isTimerRunning) { newValue in
                if newValue {
                    // Start the timer
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            // Time's up, reset the timer
                            
                            timeRemaining = restInterval
                            isTimerRunning = false
                            timer.invalidate()
                        }
                    }
                } else {
                    // Stop the timer and reset the progress bar
                    timeRemaining = restInterval
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
