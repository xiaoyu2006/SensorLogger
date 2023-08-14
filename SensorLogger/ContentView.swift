//
//  ContentView.swift
//  SensorLogger
//
//  Created by Kerman on 2023/8/13.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State var motion: CMMotionManager! = nil
    @State var accelerometersTimer: Timer? = nil
    let LOGGING_INTERVAL = 1.0 / 50.0
    
    func toggleAccelerometers() {
        if self.accelerometersTimer != nil {
            // Stop it
            self.accelerometersTimer!.invalidate()
            self.accelerometersTimer = nil
            self.motion.stopAccelerometerUpdates()
            return
        }
        
        // Start it
        self.motion.startAccelerometerUpdates()
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(Date().timeIntervalSince1970)_accelerometers")
            .appendingPathExtension("csv")
        
        if !FileManager.default.createFile(atPath: url.path, contents: nil) {
            print("File not created????")
        }
        let fileHandle = FileHandle(forWritingAtPath: url.path)
        fileHandle!.write("timestamp,x,y,z\n".data(using: .utf8)!)

        self.accelerometersTimer = Timer(fire: Date(), interval: LOGGING_INTERVAL, repeats: true) { (timer) in

            if let motionData = self.motion.accelerometerData {
                fileHandle!.write("\(Date().timeIntervalSince1970),\(motionData.acceleration.x),\(motionData.acceleration.y),\(motionData.acceleration.z)\n".data(using: .utf8)!)
            }
        }
        RunLoop.current.add(self.accelerometersTimer!, forMode: .default)
    }
    
    var body: some View {
        VStack {
            Button(action: toggleAccelerometers) {
                (self.accelerometersTimer == nil) ?
                Text("Start Logging Accelerometers") :
                Text("Stop Logging Accelerometers")
            }
            // TODO: Add other sensors
        }
        .padding()
        .onAppear {
            self.motion = CMMotionManager()
            self.motion.accelerometerUpdateInterval = LOGGING_INTERVAL
        }
    }
}
