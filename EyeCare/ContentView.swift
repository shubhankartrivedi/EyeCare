import SwiftUI
import UserNotifications


struct ReminderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 400)
                .accentColor(.blue)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandMenu("Application") {
                Button("Quit", action: {
                    NSApplication.shared.terminate(nil)
                })
                .keyboardShortcut("q", modifiers: [.command])
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    static let shared = AppDelegate()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if let error = error {
                print("Error requesting authorization: \(error)")
            } else {
                print("Successfully requested authorization")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received notification: \(notification)")
        completionHandler([.banner])
    }
}

struct ContentView: View {
    @State private var reminderTime = 1
    @State private var isActive = false
    @State private var timeRemaining = "00:00"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "eye.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
                Text("Rest Your Eyes Reminder")
                    .font(.title)
            }
            .padding(.bottom, 20)
            
            Stepper(value: $reminderTime, in: 1...120) {
                Text("Remind me every \(reminderTime) minutes")
                    .foregroundColor(.secondary)
            }
            
            Button(isActive ? "Stop" : "Start") {
                isActive.toggle()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.accentColor)
                
                Text(timeRemaining)
                    .font(.system(size: 50, weight: .thin, design: .rounded))
                    
            }
            .frame(width: 200, height: 200)
            .padding(.bottom, 30)
            
            
            
            
            
            Spacer()
        }
        .padding()
        .onReceive(
            Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            perform: { _ in
                if isActive {
                    let secondsRemaining = Int(reminderTime * 60) - Int(Date().timeIntervalSince1970
                        .truncatingRemainder(dividingBy: Double(reminderTime * 60)))
                        let minutes = secondsRemaining / 60
                        let seconds = secondsRemaining % 60
                        timeRemaining = String(format: "%02d:%02d", minutes, seconds)
                        print(secondsRemaining)
                        if secondsRemaining == 20 {
                            
                            sendNotification()
                        }
                    } else {
                        timeRemaining = "00:00"
                        
                    }
                }
            )
        }
        
        private func sendNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Rest Your Eyes"
            content.body = "It's time to give your eyes a break!"
            content.sound = UNNotificationSound.defaultCritical

            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error sending notification: \(error)")
                } else {
                    print("Notification sent successfully")
                }
            }
        }
    }
