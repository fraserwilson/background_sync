import Flutter
import UIKit
import HealthKit

public class SwiftHealthPlugin: NSObject, FlutterPlugin {
    private let healthStore = HKHealthStore()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.example.health_integration/health", binaryMessenger: registrar.messenger())
        let instance = SwiftHealthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSteps":
            getSteps(result: result)
        case "getHeartRate":
            getHeartRate(result: result)
        case "getActiveCaloriesBurned":
            getActiveCaloriesBurned(result: result)
        case "getRestingCaloriesBurned":
            getRestingCaloriesBurned(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getSteps(result: @escaping FlutterResult) {
        guard HKHealthStore.isHealthDataAvailable() else {
            result(FlutterError(code: "UNAVAILABLE", message: "Health data not available", details: nil))
            return
        }

        let readType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        requestAuthorization(toRead: [readType]) { success, error in
            if !success {
                result(FlutterError(code: "AUTHORIZATION_DENIED", message: "Authorization denied", details: nil))
                return
            }
            self.fetchStatistics(for: readType, unit: HKUnit.count(), result: result)
        }
    }

    private func getHeartRate(result: @escaping FlutterResult) {
        guard HKHealthStore.isHealthDataAvailable() else {
            result(FlutterError(code: "UNAVAILABLE", message: "Health data not available", details: nil))
            return
        }

        let readType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        requestAuthorization(toRead: [readType]) { success, error in
            if !success {
                result(FlutterError(code: "AUTHORIZATION_DENIED", message: "Authorization denied", details: nil))
                return
            }
            self.fetchStatistics(for: readType, unit: HKUnit.count().unitDivided(by: HKUnit.minute()), result: result)
        }
    }

    private func getActiveCaloriesBurned(result: @escaping FlutterResult) {
        guard HKHealthStore.isHealthDataAvailable() else {
            result(FlutterError(code: "UNAVAILABLE", message: "Health data not available", details: nil))
            return
        }

        let readType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        requestAuthorization(toRead: [readType]) { success, error in
            if !success {
                result(FlutterError(code: "AUTHORIZATION_DENIED", message: "Authorization denied", details: nil))
                return
            }
            self.fetchStatistics(for: readType, unit: HKUnit.kilocalorie(), result: result)
        }
    }

    private func getRestingCaloriesBurned(result: @escaping FlutterResult) {
        guard HKHealthStore.isHealthDataAvailable() else {
            result(FlutterError(code: "UNAVAILABLE", message: "Health data not available", details: nil))
            return
        }

        let readType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        requestAuthorization(toRead: [readType]) { success, error in
            if !success {
                result(FlutterError(code: "AUTHORIZATION_DENIED", message: "Authorization denied", details: nil))
                return
            }
            self.fetchStatistics(for: readType, unit: HKUnit.kilocalorie(), result: result)
        }
    }

    private func requestAuthorization(toRead types: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: types, completion: completion)
    }

    private func fetchStatistics(for quantityType: HKQuantityType, unit: HKUnit, result: @escaping FlutterResult) {
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, statistics, error) in
            var value = 0.0
            if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: unit)
            }
            result("\(value)")
        }

        healthStore.execute(query)
    }
}
