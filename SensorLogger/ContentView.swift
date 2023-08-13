//
//  ContentView.swift
//  SensorLogger
//
//  Created by Kerman on 2023/8/13.
//

import SwiftUI
import CoreMotion

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.presentationMode.wrappedValue.dismiss()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}


struct ContentView: View {
    @State var motion: CMMotionManager! = nil
    @State var accelerometersTimer: Timer? = nil
    @State var sharingFile: URL? = nil
    @State var activityViewPresented: Bool = false
    let LOGGING_INTERVAL = 1.0 / 100.0
    
    func toggleAccelerometers() {
        if self.accelerometersTimer != nil {
            // Stop it
            self.accelerometersTimer!.invalidate()
            self.accelerometersTimer = nil
            self.activityViewPresented = true
            self.motion.stopAccelerometerUpdates()
            return
        }
        
        // Start it
        self.motion.startAccelerometerUpdates()
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(Date().timeIntervalSince1970)_accelerometers")
            .appendingPathExtension("csv")
        self.sharingFile = url
        
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
            // TODO: Add
        }
        .padding()
        .onAppear {
            self.motion = CMMotionManager()
            self.motion.accelerometerUpdateInterval = LOGGING_INTERVAL
        }
        .sheet(isPresented: $activityViewPresented, onDismiss: {
            print("Dismiss")
        }, content: {
            ActivityViewController(activityItems: [self.sharingFile!])
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
