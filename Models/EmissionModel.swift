//
//  EmissionModel.swift
//  carbon
//
//  Created by Vedant Vijay on 06/02/26.
//

import Foundation

// MARK: - Emission Category

enum EmissionCategory: String, CaseIterable, Codable, Identifiable {
    case travel = "Travel"
    case food = "Food"
    case energy = "Energy"
    case shopping = "Shopping"
    
    var id: String { rawValue }
    
    var emoji: String {
        switch self {
        case .travel: return "🚗"
        case .food: return "🍽️"
        case .energy: return "⚡"
        case .shopping: return "🛒"
        }
    }
    
    var subcategories: [EmissionSubcategory] {
        switch self {
        case .travel:
            return [
                EmissionSubcategory(name: "Car", emoji: "🚗", unit: "km", factor: 0.21),
                EmissionSubcategory(name: "Bus", emoji: "🚌", unit: "km", factor: 0.089),
                EmissionSubcategory(name: "Train", emoji: "🚆", unit: "km", factor: 0.035),
                EmissionSubcategory(name: "Flight", emoji: "✈️", unit: "km", factor: 0.255),
                EmissionSubcategory(name: "Bike", emoji: "🚲", unit: "km", factor: 0.0),
                EmissionSubcategory(name: "Motorcycle", emoji: "🏍️", unit: "km", factor: 0.113)
            ]
        case .food:
            return [
                EmissionSubcategory(name: "Beef", emoji: "🥩", unit: "kg", factor: 60.0),
                EmissionSubcategory(name: "Chicken", emoji: "🍗", unit: "kg", factor: 6.9),
                EmissionSubcategory(name: "Fish", emoji: "🐟", unit: "kg", factor: 6.1),
                EmissionSubcategory(name: "Dairy", emoji: "🧀", unit: "kg", factor: 3.2),
                EmissionSubcategory(name: "Vegetables", emoji: "🥦", unit: "kg", factor: 2.0),
                EmissionSubcategory(name: "Rice", emoji: "🍚", unit: "kg", factor: 4.5)
            ]
        case .energy:
            return [
                EmissionSubcategory(name: "Electricity", emoji: "💡", unit: "kWh", factor: 0.42),
                EmissionSubcategory(name: "Natural Gas", emoji: "🔥", unit: "m³", factor: 2.0),
                EmissionSubcategory(name: "Heating Oil", emoji: "🛢️", unit: "litre", factor: 2.68),
                EmissionSubcategory(name: "Water", emoji: "💧", unit: "m³", factor: 0.344)
            ]
        case .shopping:
            return [
                EmissionSubcategory(name: "Clothing", emoji: "👕", unit: "item", factor: 10.0),
                EmissionSubcategory(name: "Electronics", emoji: "📱", unit: "item", factor: 70.0),
                EmissionSubcategory(name: "Furniture", emoji: "🪑", unit: "item", factor: 50.0),
                EmissionSubcategory(name: "Groceries", emoji: "🛍️", unit: "bag", factor: 3.5)
            ]
        }
    }
}

// MARK: - Subcategory

struct EmissionSubcategory: Identifiable, Codable, Hashable {
    var id: String { name }
    let name: String
    let emoji: String
    let unit: String
    let factor: Double // kg CO₂ per unit
}

// MARK: - Emission Entry

struct EmissionEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var category: EmissionCategory
    var subcategoryName: String
    var subcategoryEmoji: String
    var value: Double
    var unit: String
    var calculatedKg: Double
    var date: Date
    var notes: String
    
    private static let timeFormatter: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .abbreviated
        return f
    }()
    
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
    
    var relativeTime: String {
        Self.timeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    var formattedDate: String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        return Self.dateFormatter.string(from: date)
    }
}

// MARK: - Emission Store

class EmissionStore: ObservableObject {
    @Published var entries: [EmissionEntry] = [] {
        didSet { save() }
    }
    
    private let storageKey = "EmissionEntries"
    
    init() {
        load()
    }
    
    func add(entry: EmissionEntry) {
        entries.insert(entry, at: 0)
    }
    
    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([EmissionEntry].self, from: data) {
            entries = decoded
        }
    }
    
    // MARK: - Computed Stats
    
    var todayTotal: Double {
        let cal = Calendar.current
        return entries.filter { cal.isDateInToday($0.date) }.reduce(0) { $0 + $1.calculatedKg }
    }
    
    var weeklyTotal: Double {
        let cal = Calendar.current
        let weekAgo = cal.date(byAdding: .day, value: -7, to: Date())!
        return entries.filter { $0.date >= weekAgo }.reduce(0) { $0 + $1.calculatedKg }
    }
    
    var monthlyTotal: Double {
        let cal = Calendar.current
        let monthAgo = cal.date(byAdding: .day, value: -30, to: Date())!
        return entries.filter { $0.date >= monthAgo }.reduce(0) { $0 + $1.calculatedKg }
    }
    
    var entriesByDate: [(String, [EmissionEntry])] {
        let grouped = Dictionary(grouping: entries) { $0.formattedDate }
        let order = ["Today", "Yesterday"]
        return grouped.sorted { a, b in
            let aIdx = order.firstIndex(of: a.key) ?? Int.max
            let bIdx = order.firstIndex(of: b.key) ?? Int.max
            if aIdx != bIdx { return aIdx < bIdx }
            return (a.value.first?.date ?? .distantPast) > (b.value.first?.date ?? .distantPast)
        }
    }
    
    // MARK: - Chart Data
    
    /// Hourly breakdown for today (last 24h in 6 slots of 4h each)
    func todayHourlyData() -> [(label: String, value: Double)] {
        let cal = Calendar.current
        let now = Date()
        let startOfDay = cal.startOfDay(for: now)
        let slots = ["12am", "4am", "8am", "12pm", "4pm", "8pm"]
        
        var result: [(label: String, value: Double)] = []
        for i in 0..<6 {
            let slotStart = cal.date(byAdding: .hour, value: i * 4, to: startOfDay)!
            let slotEnd = cal.date(byAdding: .hour, value: (i + 1) * 4, to: startOfDay)!
            let total = entries
                .filter { $0.date >= slotStart && $0.date < slotEnd }
                .reduce(0) { $0 + $1.calculatedKg }
            result.append((label: slots[i], value: total))
        }
        return result
    }
    
    /// Daily breakdown for this week (last 7 days)
    func weeklyDailyData() -> [(label: String, value: Double)] {
        let cal = Calendar.current
        let now = Date()
        let dayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        var result: [(label: String, value: Double)] = []
        for i in stride(from: 6, through: 0, by: -1) {
            let day = cal.date(byAdding: .day, value: -i, to: now)!
            let startOfDay = cal.startOfDay(for: day)
            let endOfDay = cal.date(byAdding: .day, value: 1, to: startOfDay)!
            let weekday = cal.component(.weekday, from: day) - 1
            let total = entries
                .filter { $0.date >= startOfDay && $0.date < endOfDay }
                .reduce(0) { $0 + $1.calculatedKg }
            result.append((label: dayLabels[weekday], value: total))
        }
        return result
    }
    
    /// Weekly breakdown for this month (last 4 weeks)
    func monthlyWeeklyData() -> [(label: String, value: Double)] {
        let cal = Calendar.current
        let now = Date()
        
        var result: [(label: String, value: Double)] = []
        for i in stride(from: 3, through: 0, by: -1) {
            let weekEnd = cal.date(byAdding: .day, value: -(i * 7), to: now)!
            let weekStart = cal.date(byAdding: .day, value: -7, to: weekEnd)!
            let total = entries
                .filter { $0.date >= weekStart && $0.date < weekEnd }
                .reduce(0) { $0 + $1.calculatedKg }
            result.append((label: "W\(4 - i)", value: total))
        }
        return result
    }
    
    /// Category breakdown for a time period
    func categoryBreakdown(since daysAgo: Int) -> [(category: EmissionCategory, total: Double)] {
        let cal = Calendar.current
        let cutoff = cal.date(byAdding: .day, value: -daysAgo, to: Date())!
        let filtered = entries.filter { $0.date >= cutoff }
        
        return EmissionCategory.allCases.map { cat in
            let total = filtered.filter { $0.category == cat }.reduce(0) { $0 + $1.calculatedKg }
            return (category: cat, total: total)
        }.filter { $0.total > 0 }
    }
    
    /// Entries filtered by period
    func entries(forPeriod days: Int) -> [EmissionEntry] {
        if days == 0 {
            return entries.filter { Calendar.current.isDateInToday($0.date) }
        }
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
        return entries.filter { $0.date >= cutoff }
    }
    
    // MARK: - Contribution Graph Data
    
    /// Returns entry count per day for the last N days, aligned to week boundaries (oldest first).
    /// count == -1 means a padding cell (before the actual data range).
    func activityGrid(days: Int = 91) -> [(date: Date, count: Int)] {
        let cal = Calendar.current
        let now = Date()
        
        // Find the oldest day
        let oldestDay = cal.startOfDay(for: cal.date(byAdding: .day, value: -(days - 1), to: now)!)
        
        // Pad to align the first column to Sunday (weekday 1 in Calendar)
        let weekday = cal.component(.weekday, from: oldestDay) // 1=Sun, 2=Mon, ..., 7=Sat
        let paddingDays = weekday - 1 // number of empty cells before the first real day
        
        var result: [(date: Date, count: Int)] = []
        
        // Add padding cells
        for i in stride(from: paddingDays, to: 0, by: -1) {
            let paddingDate = cal.date(byAdding: .day, value: -i, to: oldestDay)!
            result.append((date: paddingDate, count: -1)) // -1 = padding / empty
        }
        
        // Add real data cells
        for i in 0..<days {
            let day = cal.date(byAdding: .day, value: i, to: oldestDay)!
            let startOfDay = cal.startOfDay(for: day)
            let endOfDay = cal.date(byAdding: .day, value: 1, to: startOfDay)!
            let count = entries.filter { $0.date >= startOfDay && $0.date < endOfDay }.count
            result.append((date: startOfDay, count: count))
        }
        
        return result
    }
    
    /// Current consecutive days with at least one entry (including today)
    var currentStreak: Int {
        let cal = Calendar.current
        var streak = 0
        var checkDate = Date()
        
        while true {
            let startOfDay = cal.startOfDay(for: checkDate)
            let endOfDay = cal.date(byAdding: .day, value: 1, to: startOfDay)!
            let hasEntry = entries.contains { $0.date >= startOfDay && $0.date < endOfDay }
            if hasEntry {
                streak += 1
                checkDate = cal.date(byAdding: .day, value: -1, to: startOfDay)!
            } else {
                break
            }
        }
        return streak
    }
    
    /// Longest streak ever
    var longestStreak: Int {
        let grid = activityGrid(days: 365)
        var longest = 0
        var current = 0
        
        for day in grid {
            if day.count > 0 {
                current += 1
                longest = max(longest, current)
            } else {
                current = 0
            }
        }
        return longest
    }
    
    /// Total days with at least one entry
    var totalActiveDays: Int {
        let cal = Calendar.current
        let uniqueDays = Set(entries.map { cal.startOfDay(for: $0.date) })
        return uniqueDays.count
    }
}
