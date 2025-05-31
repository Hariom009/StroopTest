
import Foundation
// Complete TestCooldownManager for background persistence
class TestCooldownManager: ObservableObject {
    static let shared = TestCooldownManager()
    
    private let cooldownDuration: TimeInterval = 14 * 24 * 60 * 60 // 14 days in seconds
    private let lastTestDateKey = "lastTestCompletionDate"
    private let cooldownEndDateKey = "cooldownEndDate"
    
     init() {}
    
    // Call this when user completes a test
    func recordTestCompletion() {
        let now = Date()
        let endDate = now.addingTimeInterval(cooldownDuration)
        
        UserDefaults.standard.set(now, forKey: lastTestDateKey)
        UserDefaults.standard.set(endDate, forKey: cooldownEndDateKey)
        UserDefaults.standard.synchronize()
        
        print("Test completed. Cooldown ends at: \(endDate)")
    }
    
    // Call this to start a new cooldown period (for testing purposes)
    func startNewCooldown() {
        recordTestCompletion()
    }
    
    // Get remaining time - this works even after app restart
    func getRemainingTime() -> TimeInterval {
        guard let endDate = UserDefaults.standard.object(forKey: cooldownEndDateKey) as? Date else {
            // No cooldown active - user can take test
            return 0
        }
        
        let now = Date()
        let remaining = endDate.timeIntervalSince(now)
        
        if remaining <= 0 {
            // Cooldown has expired, clean up stored dates
            clearCooldown()
            return 0
        }
        
        return remaining
    }
    
    // Check if user can take test
    func canTakeTest() -> Bool {
        return getRemainingTime() <= 0
    }
    
    // Get when the cooldown will end
    func getCooldownEndDate() -> Date? {
        return UserDefaults.standard.object(forKey: cooldownEndDateKey) as? Date
    }
    
    // Get when the last test was taken
    func getLastTestDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastTestDateKey) as? Date
    }
    
    // Clear cooldown (for testing or when cooldown expires)
    private func clearCooldown() {
        UserDefaults.standard.removeObject(forKey: lastTestDateKey)
        UserDefaults.standard.removeObject(forKey: cooldownEndDateKey)
        UserDefaults.standard.synchronize()
    }
    
    // For debugging - get cooldown info
    func getCooldownInfo() -> String {
        let remaining = getRemainingTime()
        if remaining <= 0 {
            return "No active cooldown - can take test"
        }
        
        let days = Int(remaining) / (24 * 3600)
        let hours = (Int(remaining) % (24 * 3600)) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        
        return "Cooldown: \(days) days \(hours) hours \(minutes) minutes remaining"
    }
}
