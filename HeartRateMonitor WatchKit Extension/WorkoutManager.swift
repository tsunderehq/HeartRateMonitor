//
//  WorkoutManager.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Hiroya Kawase on 2021/06/27.
//
import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    var workoutType: HKWorkoutActivityType? {
        didSet {
            guard let workoutType = workoutType else { return }
            startWorkout(workoutType: workoutType)
        }
    }
    
    let viewModel = ViewModel()
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        
        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }
        
        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self
        
        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.activitySummaryType()
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if let e = error {
                print("[workoutManager] Error: \(e.localizedDescription)")
                return
            }
            if success {
                print("[workoutManager] Success: authorization")
            }
        }
    }
    
    // MARK: - Session State Control
    
    // The app's workout state.
    @Published var running = false
    
    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func pause() {
        print("[workoutManager] Pause")
        session?.pause()
    }
    
    func resume() {
        print("[workoutManager] Resume")
        session?.resume()
    }
    
    func endWorkout() {
        print("[workoutManager] End")
        session?.end()
    }
    
    // MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var workout: HKWorkout?
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        let heartRateUnit = HKUnit(from: "count/min")
        let averageHeartRate = round(statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0)
        let heartRate = round(statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0)
        let time = round((builder?.elapsedTime ?? 0) * 1000)
        self.viewModel.session.sendMessage(["time": String(time), "heartRate": String(heartRate)], replyHandler: nil) { e in
            print("[workoutManager] Error: \(e.localizedDescription)")
        }
        print("[workoutManager] time: \(time), heartRate: \(heartRate)")
        DispatchQueue.main.async {
            self.averageHeartRate = averageHeartRate
            self.heartRate = heartRate
        }
    }
    
    func resetWorkout() {
        print("[workoutManager] Reset")
        workoutType = nil
        builder = nil
        workout = nil
        session = nil
        averageHeartRate = 0
        heartRate = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    print("[workoutManager] " + workout!.debugDescription)
                    if let e = error {
                        print("[workoutManager] Error: \(e.localizedDescription)")
                        return
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
