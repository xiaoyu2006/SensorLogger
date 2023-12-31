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
    @State var gyrosTimer: Timer? = nil
    @State var magnetometersTimer: Timer? = nil
    @State var deviceMotionTimer: Timer? = nil
    
    let LOGGING_INTERVAL = 1.0 / 50.0
    
    func toggleDeviceMotion() {
        if self.deviceMotionTimer != nil {
            // Stop it
            self.deviceMotionTimer!.invalidate()
            self.deviceMotionTimer = nil
            self.motion.stopDeviceMotionUpdates()
            return
        }
        
        // Start it
        self.motion.startDeviceMotionUpdates()
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(Date().timeIntervalSince1970)_deviceMotion")
            .appendingPathExtension("csv")
        
        if !FileManager.default.createFile(atPath: url.path, contents: nil) {
            print("File not created????")
        }
        let fileHandle = FileHandle(forWritingAtPath: url.path)
        fileHandle!.write("timestamp,altroll,altpitch,altyaw,rotx,roty,rotz,gravx,gravy,gravz,usracclx,usraccly,usracclz\n".data(using: .utf8)!)

        self.deviceMotionTimer = Timer(fire: Date(), interval: LOGGING_INTERVAL, repeats: true) { (timer) in

            if let motionData = self.motion.deviceMotion {
                fileHandle!.write("\(Date().timeIntervalSince1970),\(motionData.attitude.roll),\(motionData.attitude.pitch),\(motionData.attitude.yaw),\(motionData.rotationRate.x),\(motionData.rotationRate.y),\(motionData.rotationRate.z),\(motionData.gravity.x),\(motionData.gravity.y),\(motionData.gravity.z),\(motionData.userAcceleration.x),\(motionData.userAcceleration.y),\(motionData.userAcceleration.z)\n".data(using: .utf8)!)
            }
        }
        RunLoop.current.add(self.deviceMotionTimer!, forMode: .default)
    }
    
    
    
    func toggleMagnometers() {
        if self.magnetometersTimer != nil {
            // Stop it
            self.magnetometersTimer!.invalidate()
            self.magnetometersTimer = nil
            self.motion.stopMagnetometerUpdates()
            return
        }
        
        // Start it
        self.motion.startMagnetometerUpdates()
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(Date().timeIntervalSince1970)_magnetometers")
            .appendingPathExtension("csv")
        
        if !FileManager.default.createFile(atPath: url.path, contents: nil) {
            print("File not created????")
        }
        let fileHandle = FileHandle(forWritingAtPath: url.path)
        fileHandle!.write("timestamp,x,y,z\n".data(using: .utf8)!)

        self.magnetometersTimer = Timer(fire: Date(), interval: LOGGING_INTERVAL, repeats: true) { (timer) in

            if let motionData = self.motion.magnetometerData {
                fileHandle!.write("\(Date().timeIntervalSince1970),\(motionData.magneticField.x),\(motionData.magneticField.y),\(motionData.magneticField.z)\n".data(using: .utf8)!)
            }
        }
        RunLoop.current.add(self.magnetometersTimer!, forMode: .default)
    }
    
    func toggleGyros() {
        if self.gyrosTimer != nil {
            // Stop it
            self.gyrosTimer!.invalidate()
            self.gyrosTimer = nil
            self.motion.stopGyroUpdates()
            return
        }
        
        // Start it
        self.motion.startGyroUpdates()
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(Date().timeIntervalSince1970)_gyros")
            .appendingPathExtension("csv")
        
        if !FileManager.default.createFile(atPath: url.path, contents: nil) {
            print("File not created????")
        }
        let fileHandle = FileHandle(forWritingAtPath: url.path)
        fileHandle!.write("timestamp,x,y,z\n".data(using: .utf8)!)

        self.gyrosTimer = Timer(fire: Date(), interval: LOGGING_INTERVAL, repeats: true) { (timer) in

            if let motionData = self.motion.gyroData {
                fileHandle!.write("\(Date().timeIntervalSince1970),\(motionData.rotationRate.x),\(motionData.rotationRate.y),\(motionData.rotationRate.z)\n".data(using: .utf8)!)
            }
        }
        RunLoop.current.add(self.gyrosTimer!, forMode: .default)
    }
    
    
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
        VStack(alignment: .leading, spacing: 10.0) {
            Button(action: toggleAccelerometers) {
                (self.accelerometersTimer == nil) ?
                Text("Start Logging Accelerometers") :
                Text("Stop Logging Accelerometers")
            }
            Button(action: toggleGyros) {
                (self.gyrosTimer == nil) ?
                Text("Start Logging Gyros") :
                Text("Stop Logging Gyros")
            }
            Button(action: toggleMagnometers) {
                (self.magnetometersTimer == nil) ?
                Text("Start Logging Magnometers") :
                Text("Stop Logging Magnometers")
            }
            Button(action: toggleDeviceMotion) {
                (self.deviceMotionTimer == nil) ?
                Text("Start Logging Device Motion") :
                Text("Stop Logging Device Motion")
            }
            Text("Note: Data are retreved from Apple's sensors, acceleration is in g, rotation rate is in rad/s, magnetic field is in microteslas.")
            
            // TODO: Add other sensors
        }
        .padding()
        .onAppear {
            self.motion = CMMotionManager()
            self.motion.accelerometerUpdateInterval = LOGGING_INTERVAL
            self.motion.gyroUpdateInterval = LOGGING_INTERVAL
            self.motion.magnetometerUpdateInterval = LOGGING_INTERVAL
            self.motion.deviceMotionUpdateInterval = LOGGING_INTERVAL
        }
    }
}
